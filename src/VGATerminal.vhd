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
use IEEE.NUMERIC_STD.ALL;

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
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
  );
END COMPONENT;

signal vga_clk : std_logic;
signal row : unsigned(10 downto 0);
signal col : unsigned(10 downto 0);
signal row_out : std_logic_vector(10 downto 0);
signal col_out : std_logic_vector(10 downto 0);
signal vga_ena : std_logic;
signal color : std_logic;
signal vga_value : std_logic_vector(3 downto 0);

signal uart_recv_data : std_logic_vector(7 downto 0);
signal uart_in : unsigned(7 downto 0);
signal char_addr : unsigned(7 downto 0);
signal uart_rdy : std_logic;

signal load_ram : std_logic_vector(0 downto 0);
signal ram_out : std_logic_vector(5 downto 0);
signal ram_write_addr : unsigned(10 downto 0);
signal ram_read_addr : unsigned(10 downto 0);

signal char_row : unsigned(5 downto 0);
signal char_col : unsigned(5 downto 0);

begin

process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        if uart_rdy = '1' then
            ram_write_addr <= ram_write_addr + 1;
            
            if ram_write_addr > 1198 then
                ram_write_addr <= "00000000000";
            end if;
            
            load_ram <= "1";
            
            if uart_in > 95 then
                char_addr <= uart_in - 64;
            elsif uart_in > 31 then
                char_addr <= uart_in - 32;
            else
                char_addr <= uart_in;
            end if;
        else
            load_ram <= "0";
        end if;
    end if;
end process;

uart_in <= unsigned(uart_recv_data);

vga_value <= "0000" when color = '0' else "1111";

VGA_R <= vga_value;
VGA_G <= vga_value;
VGA_B <= vga_value;

row <= unsigned(row_out);
col <= unsigned(col_out);

char_row <= row(9 downto 4);
char_col <= col(9 downto 4);

ram_read_addr <= resize(char_row * 40 + char_col, 11);

crom : CharROM
port map (
    char_addr => ram_out,
    font_row => std_logic_vector(row(3 downto 1)),
    font_col => std_logic_vector(col(3 downto 1)),
    rom_out => color
);

vga : VGADriver
port map (
    VGA_HS => VGA_HS,
    VGA_VS => VGA_VS,
    pixel_row => row_out,
    pixel_col => col_out,
    enable => vga_ena,
    clk_VGA => vga_clk,
    reset => '0'
);

uart : UARTReceiver
port map (
    UART_TXD_IN => UART_TXD_IN,
    CLK100MHZ => CLK100MHZ,
    data_out => uart_recv_data,
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
     wea => load_ram,
     addra => std_logic_vector(ram_write_addr),
     dina => std_logic_vector(char_addr(5 downto 0)),
     clkb => CLK100MHZ,
     addrb => std_logic_vector(ram_read_addr),
     doutb => ram_out
   );

end Behavioral;
