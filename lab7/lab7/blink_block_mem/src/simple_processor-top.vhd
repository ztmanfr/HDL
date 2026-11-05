-------------------------------------------------------------------------------
-- Laboratory 7: Simple Processor [8-bit] Reference Implementation
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_processor_top is
  port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    execute_btn : in  std_logic;
    led_state   : out std_logic_vector(3 downto 0); -- Present state LEDs
    seg0        : out std_logic_vector(6 downto 0); -- Units
    seg1        : out std_logic_vector(6 downto 0); -- Tens
    seg2        : out std_logic_vector(6 downto 0)  -- Hundreds
  );
end simple_processor_top;

architecture rtl of simple_processor_top is

  -- Component Declarations
  component seven_seg is
    port (
      bcd           : in  std_logic_vector(3 downto 0);
      seven_seg_out : out std_logic_vector(6 downto 0)
    );
  end component;

  -- Signals for Button Synchronization & Edge Detection
  signal btn_sync1, btn_sync2, btn_edge : std_logic := '0';
  
  -- FSM States
  type state_type is (IDLE, FETCH, EXECUTE, WRITEBACK);
  signal current_state, next_state : state_type := IDLE;

  -- PC and ROM signals
  signal pc : unsigned(3 downto 0) := (others => '0');
  signal instruction : std_logic_vector(11 downto 0); -- 4-bit opcode + 8-bit immediate
  
  -- Memory (4 x 8-bit register file)
  type mem_array is array (0 to 3) of unsigned(7 downto 0);
  signal reg_mem : mem_array := (others => (others => '0'));
  signal mem_ptr : unsigned(1 downto 0) := "00";

  -- ALU Signals
  signal op_a, op_b, alu_result : unsigned(7 downto 0) := (others => '0');
  signal opcode : std_logic_vector(3 downto 0);

  -- BCD Conversion signals for 3 digits
  signal result_reg : unsigned(7 downto 0) := (others => '0');
  signal hundreds, tens, units : std_logic_vector(3 downto 0);

begin

  -----------------------------------------------------------------------------
  -- 1. Input Synchronization & Rising Edge Detector for Execute Button
  -----------------------------------------------------------------------------
  process(clk, reset)
  begin
    if reset = '1' then
      btn_sync1 <= '0';
      btn_sync2 <= '0';
      btn_edge  <= '0';
    elsif rising_edge(clk) then
      btn_sync1 <= execute_btn;
      btn_sync2 <= btn_sync1;
      btn_edge  <= btn_sync2 and (not btn_sync1); -- Rising edge pulse
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- 2. Inferred Block ROM (Instructions: Opcode [11:8] & Operand [7:0])
  -----------------------------------------------------------------------------
  -- Opcodes: "0001" = ADD, "0010" = SUB, "0011" = MUL, "0100" = DIV
  process(pc)
  begin
    case to_integer(pc) is
      when 0      => instruction <= "0001" & x"0A"; -- ADD 10
      when 1      => instruction <= "0001" & x"05"; -- ADD 5
      when 2      => instruction <= "0010" & x"03"; -- SUB 3
      when 3      => instruction <= "0011" & x"02"; -- MUL 2
      when others => instruction <= (others => '0');
    end case;
  end process;

  -----------------------------------------------------------------------------
  -- 3. Processor FSM (Sequential Logic)
  -----------------------------------------------------------------------------
  process(clk, reset)
  begin
    if reset = '1' then
      current_state <= IDLE;
      pc            <= (others => '0');
      mem_ptr       <= "00";
      reg_mem       <= (others => (others => '0'));
      result_reg    <= (others => '0');
    elsif rising_edge(clk) then
      case current_state is
        when IDLE =>
          if btn_edge = '1' then
            current_state <= FETCH;
          end if;

        when FETCH =>
          current_state <= EXECUTE;

        when EXECUTE =>
          -- Assign inputs to ALU
          op_a   <= reg_mem(to_integer(mem_ptr));
          op_b   <= unsigned(instruction(7 downto 0));
          opcode <= instruction(11 downto 8);
          current_state <= WRITEBACK;

        when WRITEBACK =>
          -- Store result and increment pointers
          reg_mem(to_integer(mem_ptr + 1)) <= alu_result;
          mem_ptr    <= mem_ptr + 1;
          result_reg <= alu_result;
          pc         <= pc + 1;
          current_state <= IDLE;

        when others =>
          current_state <= IDLE;
      end case;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- 4. Combinational ALU (Unsigned Base 256)
  -----------------------------------------------------------------------------
  process(op_a, op_b, opcode)
  begin
    case opcode is
      when "0001" => -- ADD
        alu_result <= op_a + op_b;
      when "0010" => -- SUB
        alu_result <= op_a - op_b; -- Unsigned wrap-around (e.g., 0 - 1 = 255)
      when "0011" => -- MUL
        alu_result <= resize((op_a * op_b), 8);
      when "0100" => -- DIV
        if op_b = 0 then
          alu_result <= (others => '0');
        else
          alu_result <= op_a / op_b;
        end if;
      when others =>
        alu_result <= op_a;
    end case;
  end process;

  -----------------------------------------------------------------------------
  -- 5. Binary to Decimal BCD Conversion for 3 Seven Segment Displays
  -----------------------------------------------------------------------------
  process(result_reg)
    variable temp : integer;
  end process;
  
  -- Simplified BCD math conversion for 8-bit unsigned values (0 to 255)
  hundreds <= std_logic_vector(to_unsigned(to_integer(result_reg) / 100, 4));
  tens     <= std_logic_vector(to_unsigned((to_integer(result_reg) / 10) mod 10, 4));
  units    <= std_logic_vector(to_unsigned(to_integer(result_reg) mod 10, 4));

  -- Instantiate Seven Segment Drivers
  seg_unit_inst : seven_seg port map (bcd => units, seven_seg_out => seg0);
  seg_tens_inst : seven_seg port map (bcd => tens,  seven_seg_out => seg1);
  seg_huns_inst : seven_seg port map (bcd => hundreds, seven_seg_out => seg2);

  -- State indicator LEDs
  process(current_state)
  begin
    case current_state is
      when IDLE      => led_state <= "0001";
      when FETCH     => led_state <= "0010";
      when EXECUTE   => led_state <= "0100";
      when WRITEBACK => led_state <= "1000";
    end case;
  end process;

end rtl;