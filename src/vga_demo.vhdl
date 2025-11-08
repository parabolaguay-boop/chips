library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tt_um_vga_demo is
  port (
    ui_in   : in std_logic_vector(7 downto 0);
    uo_out  : out std_logic_vector(7 downto 0);
    uio_in  : in std_logic_vector(7 downto 0);
    uio_out : out std_logic_vector(7 downto 0);
    uio_oe  : out std_logic_vector(7 downto 0);
    ena     : in std_logic;
    clk     : in std_logic;
    rst_n   : in std_logic
  );
end tt_um_vga_demo;

architecture rtl of tt_um_vga_demo is

  signal hsync, vsync : std_logic;
  signal R, G, B      : std_logic_vector(1 downto 0);
  signal video_active : std_logic;
  signal pix_x, pix_y : std_logic_vector(9 downto 0);


  type mem is array (0 to 15) of std_logic_vector(9 downto 0);
  constant rom : mem := (
    0  => "0000000000",
    1  => "0000000100",
    2  => "0000001000",
    3  => "0000001100",
    4  => "0000010000",
    5  => "0001100100",
    6  => "0001100100",
    7  => "1111000000",
    8  => "1111000000",
    9  => "1111000000",
    10 => "1111000000",
    11 => "1111000000",
    12 => "1111000000",
    13 => "1111000000",
    14 => "1111000000",
    15 => "1111000000");

  component vga_sync_gen
  port (
    clk        : in std_logic;
    reset      : in std_logic;
    hsync      : out std_logic;
    vsync      : out std_logic;
    display_on : out std_logic;
    hpos       : out std_logic_vector(9 downto 0);
    vpos       : out std_logic_vector(9 downto 0)
  );
  end component;

begin

  uo_out <= hsync & B(0) & G(0) & R(0) & vsync & B(1) & G(1) & R(1);

  vga_sync_gen_inst : vga_sync_gen
    port map
    (
      clk        => clk,
      reset      => rst_n,
      hsync      => hsync,
      vsync      => vsync,
      display_on => video_active,
      hpos       => pix_x,
      vpos       => pix_y
    );

  B <= (11) when (pix_x = "0000000100" and video_active = '1') else
    "00";

  R <= --(pix_x(0) & pix_y(4)) when video_active = '1' else
    "00";
  G <= --(pix_x(1) & pix_y(2)) when video_active = '1' else
    "00";
  --B <= (pix_x(2) & pix_y(3)) when video_active = '1' else
    --"00";

  uio_oe  <= "00000000";
  uio_out <= "00000000";

end architecture;