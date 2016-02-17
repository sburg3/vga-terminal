----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2016 09:10:15 PM
-- Design Name: 
-- Module Name: VGATerminal - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGATerminal is
    Port ( CLK100MHZ : in STD_LOGIC;
           UART_TXD_IN : in STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           VGA_HS : out STD_LOGIC;
           VGA_R : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out STD_LOGIC_VECTOR (3 downto 0));
end VGATerminal;

architecture Behavioral of VGATerminal is

component CharROM is
    Port ( char_addr : in STD_LOGIC_VECTOR (5 downto 0);
           font_row : in STD_LOGIC_VECTOR (2 downto 0);
           font_col : in STD_LOGIC_VECTOR (2 downto 0);
           rom_out : out STD_LOGIC);
end component;

component VGADriver is
    Port ( VGA_HS : out STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           pixel_row : out STD_LOGIC_VECTOR (10 downto 0);
           pixel_col : out STD_LOGIC_VECTOR (10 downto 0);
           enable : out STD_LOGIC;
           clk_VGA : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component UARTReceiver is
    Generic ( baud : integer := 9600);
    Port ( UART_TXD_IN : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           data_ready : out STD_LOGIC);
end component;

component clk_wiz_0
port
 (-- Clock in ports
  clk_in1           : in     std_logic;
  -- Clock out ports
  clk_out1          : out    std_logic
 );
end component;

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
  );
END COMPONENT;

signal vga_clk : std_logic;
signal row : unsigned(10 downto 0);
signal col : unsigned(10 downto 0);
signal vga_ena : std_logic;

signal uart_in : unsigned(7 downto 0);
signal char_addr : unsigned(7 downto 0);
signal uart_rdy : std_logic;

begin

process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        if uart_rdy = '1' then
            if uart_in > 95 then
                char_addr <= uart_in - 64;
            elsif uart_in > 31 then
                char_addr <= uart_in - 32;
            else
                char_addr <= uart_in;
            end if;
        end if;
    end if;
end process;

crom : CharROM
port map (
    char_addr => char_addr,
    font_row => open,
    font_col => open,
    rom_out => open
);

vga : VGADriver
port map (
    VGA_HS => VGA_HS,
    VGA_VS => VGA_VS,
    pixel_row => row,
    pixel_col => col,
    enable => vga_ena,
    clk_VGA => vga_clk,
    reset => '0'
);

uart : UARTReciever
port map (
    UART_TXD_IN => UART_TXD_IN,
    CLK100MHZ => CLK100MHZ,
    data_out => std_logic_vector(uart_in),
    data_ready => uart_rdy
);

cw0 : clk_wiz_0
   port map ( 

   -- Clock in ports
   clk_in1 => CLK100MHZ,
  -- Clock out ports  
   clk_out1 => vga_clk              
 );
 
addrram : blk_mem_gen_0
   PORT MAP (
     clka => CLK100MHZ,
     wea => open,
     addra => open,
     dina => open,
     douta => open
 );

end Behavioral;
