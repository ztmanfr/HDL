library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dj_roomba_3000 is
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(7 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end dj_roomba_3000;

architecture beh of dj_roomba_3000 is
  component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (7 DOWNTO 0)
    );
  end component;

  component rom_data
    port(
      address  : in std_logic_vector (13 DOWNTO 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 DOWNTO 0)
    );
  end component;

  type state_type is (idle, fetch, latch_instr, decode, execute, decode_error);
  type instr_type is (PLAY_ONCE, PLAY_REPEAT, PAUSE, SEEK, STOP, ERROR_INSTR);

  signal state_reg                  : state_type;
  signal state_next                 : state_type;

  signal pc                         : unsigned(4 downto 0);
  signal instr_q                    : std_logic_vector(7 downto 0);
  signal instr_reg                  : std_logic_vector(7 downto 0);
  signal instruction                : instr_type;
  signal repeat                     : std_logic;
  signal opcode                     : std_logic_vector(1 downto 0);
  signal seek_address               : std_logic_vector(4 downto 0);

  signal data_address               : unsigned(13 downto 0);
  signal data_address_reg           : unsigned(13 downto 0);
  signal data_address_play          : unsigned(13 downto 0);
  signal data_address_play_repeat   : unsigned(13 downto 0);
  signal data_address_stop          : unsigned(13 downto 0);
  signal data_address_seek          : unsigned(13 downto 0);
  signal data_address_pause         : unsigned(13 downto 0);
  signal data_q                     : std_logic_vector(15 downto 0);

  signal playing                    : std_logic;
  signal btn_ff1                    : std_logic;
  signal btn_ff2                    : std_logic;
  signal btn_prev                   : std_logic;
  signal edge                       : std_logic;

begin

  u_rom_inst : rom_instructions
    port map (
      address => std_logic_vector(pc),
      clock   => clk,
      q       => instr_q
    );

  u_rom_data_inst : rom_data
    port map (
      address => std_logic_vector(data_address),
      clock   => clk,
      q       => data_q
    );

  -- Synchronize execute_btn and generate rising edge
  process(clk, reset)
  begin
    if (reset = '1') then
      btn_ff1  <= '0';
      btn_ff2  <= '0';
      btn_prev <= '0';
    elsif rising_edge(clk) then
      btn_ff1  <= execute_btn;
      btn_ff2  <= btn_ff1;
      btn_prev <= btn_ff2;
    end if;
  end process;

  edge <= '1' when (btn_ff2 = '1' and btn_prev = '0') else '0';

  opcode       <= instr_reg(7 downto 6);
  repeat       <= instr_reg(5) when (opcode = "00") else '0';
  seek_address <= instr_reg(4 downto 0) when (opcode = "10") else (others => '0');

  process(opcode, repeat, seek_address)
  begin
    case opcode is
      when "00" =>
        if (repeat = '1') then
          instruction <= PLAY_REPEAT;
        else
          instruction <= PLAY_ONCE;
        end if;
      when "01" =>
        instruction <= PAUSE;
      when "10" =>
        if (seek_address = "00000") then
          instruction <= ERROR_INSTR;
        else
          instruction <= SEEK;
        end if;
      when "11" =>
        instruction <= STOP;
      when others =>
        instruction <= ERROR_INSTR;
    end case;
  end process;

  -- Next-state logic
  process(state_reg, edge, instr_reg)
  begin
    state_next <= state_reg;
    case state_reg is
      when idle =>
        if (edge = '1') then
          state_next <= fetch;
        end if;

      when fetch =>
        state_next <= latch_instr;

      when latch_instr =>
        state_next <= decode;

      when decode =>
        if (instr_reg(7 downto 6) = "10" and instr_reg(4 downto 0) = "00000") then
          state_next <= decode_error;
        else
          state_next <= execute;
        end if;

      when execute =>
        state_next <= idle;

      when decode_error =>
        state_next <= idle;
    end case;
  end process;

  -- Sequential state, PC, execution, and data address tracking
  process(clk, reset)
    variable addr_tmp : unsigned(13 downto 0);
  begin
    if (reset = '1') then
      state_reg                  <= idle;
      pc                         <= (others => '0');
      instr_reg                  <= (others => '0');
      data_address               <= (others => '0');
      data_address_reg           <= (others => '0');
      data_address_play          <= (others => '0');
      data_address_play_repeat   <= (others => '0');
      data_address_stop          <= (others => '0');
      data_address_seek          <= (others => '0');
      data_address_pause         <= (others => '0');
      playing                    <= '0';
    elsif rising_edge(clk) then
      state_reg <= state_next;

      addr_tmp := data_address;
      if (playing = '1' and sync = '1') then
        if (data_address = to_unsigned(16383, 14)) then
          if (instr_reg(5) = '1') then
            addr_tmp := (others => '0');
          else
            addr_tmp := data_address;
            playing  <= '0';
          end if;
        else
          addr_tmp := data_address + 1;
        end if;
        data_address     <= addr_tmp;
        data_address_reg <= addr_tmp;
      end if;

      case state_reg is
        when idle =>
          null;

        when fetch =>
          null;

        when latch_instr =>
          instr_reg <= instr_q;

        when decode =>
          null;

        when execute =>
          case instr_reg(7 downto 6) is
            when "00" =>
              playing <= '1';
              if (instr_reg(5) = '1') then
                data_address_play_repeat <= addr_tmp;
              else
                data_address_play <= addr_tmp;
              end if;

            when "01" =>
              playing            <= '0';
              data_address_pause <= data_address;

            when "10" =>
              addr_tmp          := unsigned(instr_reg(4 downto 0) & "000000000");
              data_address      <= addr_tmp;
              data_address_reg  <= addr_tmp;
              data_address_seek <= addr_tmp;

            when "11" =>
              playing           <= '0';
              data_address      <= (others => '0');
              data_address_reg  <= (others => '0');
              data_address_stop <= (others => '0');

            when others =>
              null;
          end case;
          pc <= pc + 1;

        when decode_error =>
          pc <= pc + 1;
      end case;
    end if;
  end process;

  led       <= instr_reg;
  audio_out <= data_q when (playing = '1') else (others => '0');

end beh;