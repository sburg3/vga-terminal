----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2016 09:20:29 PM
-- Design Name: 
-- Module Name: CharROM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CharROM is
    Port ( char_addr : in STD_LOGIC_VECTOR (5 downto 0);
           font_row : in STD_LOGIC_VECTOR (2 downto 0);
           font_col : in STD_LOGIC_VECTOR (2 downto 0);
           rom_out : out STD_LOGIC);
end CharROM;

architecture Behavioral of CharROM is

COMPONENT dist_mem_gen_0
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal rom_addr : std_logic_vector(8 downto 0);
signal rom_int : std_logic_vector(7 downto 0);

begin

rom_addr <= char_addr & font_row;
rom_out <= rom_int(to_integer(unsigned(not font_col)));

rom : dist_mem_gen_0
  PORT MAP (
    a => rom_addr,
    spo => rom_int
  );


end Behavioral;
