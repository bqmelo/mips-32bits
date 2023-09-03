library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity data_path is
  Port (
    clk                 : in  std_logic;
    rst_n               : in  std_logic;
    jmp_sel             : in  std_logic;
    alu_mem_sel         : in  std_logic;
    adress_sel           : in  std_logic; -- tipo adress_sel
    pc_en               : in  std_logic;
    ir_en               : in  std_logic;
    data_en             : in  std_logic;
    write_reg_en        : in  std_logic;
    alu_op              : in  std_logic_vector (5 downto 0);
    adress_pc           : out std_logic_vector (8 downto 0);
    decoded_inst        : out decoded_instruction_type;
    
    flag_z              : out std_logic;
    flag_n              : out std_logic;
    
    mem_write_sel       : in  std_logic;
    alu_a_sel           : in  std_logic;
    saida_memoria       : in  std_logic_vector (31 downto 0);
    entrada_memoria     : out std_logic_vector (31 downto 0)

  );
end data_path;

architecture rtl of data_path is


    signal data                 : std_logic_vector (15 downto 0);
    signal alu_or_mem_data      : std_logic_vector (15 downto 0);
    signal instruction          : std_logic_vector (31 downto 0); 
    signal mem_addr             : std_logic_vector (8  downto 0); 
    signal program_counter      : std_logic_vector (8  downto 0); 
    signal out_pc_mux           : std_logic_vector (8  downto 0); 
    signal b_alu                : std_logic_vector (15 downto 0);
    signal dr_to_reg            : std_logic_vector (15 downto 0);

    
    -- registers
     signal reg1                : std_logic_vector (15 downto 0);
     signal reg2                : std_logic_vector (15 downto 0);
     signal reg3                : std_logic_vector (15 downto 0);
     signal reg4                : std_logic_vector (15 downto 0);
     signal reg5                : std_logic_vector (15 downto 0);
     signal reg6                : std_logic_vector (15 downto 0);
     signal reg7                : std_logic_vector (15 downto 0);
     signal reg8                : std_logic_vector (15 downto 0);
     signal reg9                : std_logic_vector (15 downto 0);
     signal reg10               : std_logic_vector (15 downto 0);
     signal reg11               : std_logic_vector (15 downto 0);
     signal reg12               : std_logic_vector (15 downto 0);
     signal reg13               : std_logic_vector (15 downto 0);
     signal reg14               : std_logic_vector (15 downto 0);
     signal reg15               : std_logic_vector (15 downto 0);
     signal reg16               : std_logic_vector (15 downto 0);
     
     signal reg_inst_mem        : std_logic_vector (14 downto 0); 
     signal mem_data_reg        : std_logic_vector (15 downto 0);
     signal reg_a_ula           : std_logic_vector (15 downto 0);
     signal reg_b_ula           : std_logic_vector (15 downto 0);
     signal reg_ula_out         : std_logic_vector (15 downto 0);
     
    -- target register
      
    signal reg_dest     : std_logic_vector(3 downto 0);
    signal reg_dest_duo : std_logic_vector(3 downto 0);
    
    -- Reg A  
    signal reg_op_a     : std_logic_vector(3 downto 0);
    signal reg_a_alu: std_logic_vector(15 downto 0);
    
    -- Reg B  
    signal reg_op_b     : std_logic_vector(3 downto 0);
    signal reg_b_alu_out: std_logic_vector(15 downto 0);
      
   -- ALU signals
    signal a_operand    : STD_LOGIC_VECTOR (15 downto 0);      
    signal b_operand    : STD_LOGIC_VECTOR (15 downto 0);   
    signal ula_out      : STD_LOGIC_VECTOR (15 downto 0);
    
    -- FLAGS
    signal zero         : std_logic;
    signal neg          : std_logic;

begin 
   process(reg_a_alu, b_operand, alu_op)
   begin
      case alu_op is
 
         when "000001" =>  -- SUB
               ula_out <= reg_a_alu - b_operand;
         when "000010" =>  -- OR
               ula_out <= reg_a_alu or b_operand;
         when "000011" =>  -- AND
               ula_out <= reg_a_alu and b_operand;
         when "000100" =>  --ADD
               ula_out <= reg_a_alu + b_operand;
         when others =>  --others
               ula_out <= x"0000";
                
      end case;
   end process;   
   
   flag_zero : zero <= '1' when ula_out = x"0000"
               else '0'; 
   
   flag_z <= zero;
   
   mux_pc : out_pc_mux <= instruction(8 downto 0) when jmp_sel = '1'
           else program_counter + 1;

   pc_register : process(clk)
               begin
                  if (clk'event and clk ='1') then
                     if(rst_n='1') then
                        program_counter <= "000000000";
                     else if (pc_en='1') then
                           program_counter <= out_pc_mux;  --sai outmux se pc_en
                     end if;
                     end if;
                  end if;
               end process;
   
   inst_reg : process(clk)
            begin
                 if (clk'event and clk ='1') then
                    if(ir_en ='1') then
                        instruction <= saida_memoria;
                    end if;
                 end if;
            end process;

   mux_alu_or_mem : alu_or_mem_data <= saida_memoria(15 downto 0) when alu_mem_sel = '1'
                  else ula_out;

   mux_pc_or_inst : adress_pc <= instruction(8 downto 0) when adress_sel = '1'
                  else program_counter;
    
   -- novo mux para a complexa                
   mux_alu_reg_a_or_mem : reg_a_alu <= saida_memoria(15 downto 0) when alu_a_sel = '1'
                        else a_operand;
             
   banco_reg : process(clk)
            begin
               if (clk'event and clk ='1') then
                  if(rst_n='1') then --reset os regs
                        reg1    <= x"0000"; -- resultado ADD
                        reg2    <= x"000A";
                        reg3    <= x"0003";
                        reg4    <= x"0000"; -- resultado SUB
                        reg5    <= x"0001"; -- operador or 000000000000001
                        reg6    <= x"0004"; -- operador or 000000000000100
                        reg7    <= x"0000"; -- resultado OR
                        reg8    <= x"0009"; -- operador and 000000000001001
                        reg9    <= x"0000"; -- resultado AND
                        reg10   <= x"0001"; -- operando BEQ
                        reg11   <= x"000E"; -- operando BEQ
                        reg12   <= x"0000";
                        reg13   <= x"0008"; -- usado na store
                        reg14   <= x"0001"; -- lw_add operando b
                        reg15   <= x"0000"; -- lw_add destino
                        reg16   <= x"0000";
                        
                  else if (write_reg_en='1') then
                        case reg_dest is
                           when "0001" =>  --reg1
                              reg1 <= alu_or_mem_data;
                           when "0010" =>  --reg2
                              reg2 <= alu_or_mem_data;
                           when "0011" =>  --reg3
                              reg3 <= alu_or_mem_data;
                           when "0100" =>  --reg4
                              reg4 <= alu_or_mem_data;
                           when "0101" =>  --reg5
                              reg5 <= alu_or_mem_data;
                           when "0110" =>  --reg6
                              reg6 <= alu_or_mem_data;
                           when "0111" =>  --reg7
                              reg7 <= alu_or_mem_data;
                           when "1000" =>  --reg8
                              reg8 <= alu_or_mem_data;
                           when "1001" =>  --reg9
                              reg9 <= alu_or_mem_data;
                           when "1010" =>  --reg10
                              reg10 <= alu_or_mem_data;
                           when "1011" =>  --reg11
                              reg11 <= alu_or_mem_data;
                           when "1100" =>  --reg12
                              reg12 <= alu_or_mem_data;
                           when "1101" =>  --reg13
                              reg13 <= alu_or_mem_data;
                           when "1110" =>  --reg14
                              reg14 <= alu_or_mem_data;
                           when "1111" =>  --reg15
                              reg15 <= alu_or_mem_data;
                              
                           when others => --others
                              reg16 <= alu_or_mem_data;
                        end case;
                     end if; 
                  end if;    
               end if;
            end process;
   

   reg_op_a_alu : process(clk)
                  begin   
                     if (clk'event and clk ='1') then
                           case reg_op_a is
                              when "0001" =>  --reg1
                                 a_operand <= reg1;
                              when "0010" =>  --reg2
                                 a_operand <= reg2;
                              when "0011" =>  --reg3
                                 a_operand <= reg3;
                              when "0100" =>  --reg4
                                 a_operand <= reg4;
                              when "0101" =>  --reg5
                                 a_operand <= reg5;
                              when "0110" =>  --reg6
                                 a_operand <= reg6;
                              when "0111" =>  --reg7
                                 a_operand <= reg7;
                              when "1000" =>  --reg8
                                 a_operand <= reg8;
                              when "1001" =>  --reg9
                                 a_operand <= reg9;
                              when "1010" =>  --reg10
                                 a_operand <= reg10;
                              when "1011" =>  --reg11
                                 a_operand <= reg11;
                              when "1100" =>  --reg12
                                 a_operand <= reg12;
                              when "1101" =>  --reg13
                                 a_operand <= reg13;
                              when "1110" =>  --reg14
                                 a_operand <= reg14;
                              when "1111" =>  --reg15
                                 a_operand <= reg15;
                                 
                              when others => --others
                                 a_operand <= reg16;
                        end case;
                     end if;
                  end process;
     
   reg_op_b_alu : process(clk)
               begin   
                  if (clk'event and clk ='1') then
                        case reg_op_b is
                           when "0001" =>  --reg1
                              b_operand <= reg1;
                           when "0010" =>  --reg2
                              b_operand <= reg2;
                           when "0011" =>  --reg3
                              b_operand <= reg3;
                           when "0100" =>  --reg4
                              b_operand <= reg4;
                           when "0101" =>  --reg5
                              b_operand <= reg5;
                           when "0110" =>  --reg6
                              b_operand <= reg6;
                           when "0111" =>  --reg7
                              b_operand <= reg7;
                           when "1000" =>  --reg8
                              b_operand <= reg8;
                           when "1001" =>  --reg9
                              b_operand <= reg9;
                           when "1010" =>  --reg10
                              b_operand <= reg10;
                           when "1011" =>  --reg11
                              b_operand <= reg11;
                           when "1100" =>  --reg12
                              b_operand <= reg12;
                           when "1101" =>  --reg13
                              b_operand <= reg13;
                           when "1110" =>  --reg14
                              b_operand <= reg14;
                           when "1111" =>  --reg15
                              b_operand <= reg15;
                              
                           when others => --others
                              b_operand <= reg16;
                     end case;
                  end if;
               end process;       
     
   decode_instruction : process(instruction)
                        begin
                           -- sempre zera no inicio
                           reg_op_a <= "0000";
                           reg_op_b <= "0000";
                           mem_addr <= "000000000";
                           reg_dest <= "0000";
                           
                           case instruction(31 downto 26) is
                              when "000100" => -- ADD
                                 reg_dest <= instruction(25 downto 22);
                                 reg_op_a <= instruction(21 downto 18);
                                 reg_op_b <= instruction(17 downto 14);
                                 decoded_inst <= I_ADD;
                              
                              when "000001" => -- SUB
                                 reg_dest <= instruction(25 downto 22);
                                 reg_op_a <= instruction(21 downto 18);
                                 reg_op_b <= instruction(17 downto 14);
                                 decoded_inst <= I_SUB;
                                 
                              when "000010" => -- OR
                                 reg_dest <= instruction(25 downto 22);
                                 reg_op_a <= instruction(21 downto 18);
                                 reg_op_b <= instruction(17 downto 14);
                                 decoded_inst <= I_OR;
                                 
                              when "000011" => -- AND
                                 reg_dest <= instruction(25 downto 22);
                                 reg_op_a <= instruction(21 downto 18);
                                 reg_op_b <= instruction(17 downto 14);
                                 decoded_inst <= I_AND;
                                 
                              when "100000" => -- BEQ
                                 reg_op_a <= instruction(25 downto 22);
                                 reg_op_b <= instruction(21 downto 18); 
                                 decoded_inst <= I_BEQ;
                                 
                              when "100001" => -- JMP
                                 decoded_inst <= I_JMP;
                              
                              when "100010" => -- LW
                                 reg_dest <= instruction(25 downto 22);
                                 decoded_inst <= I_LOAD;
                              
                              when "100011" => -- SW
                                 reg_op_a <= instruction(25 downto 22);
                                 decoded_inst <= I_STORE;
                                 
                              when "100100" => -- LW_ADD
                                 reg_dest <= instruction(25 downto 22);
                                 reg_op_b <= instruction(21 downto 18);
                                 decoded_inst <= I_LW_ADD;
                              
                              when "100101" => -- ADD_SW
                                 reg_dest <= instruction(25 downto 22);
                                 reg_op_a <= instruction(25 downto 22);
                                 reg_op_b <= instruction(21 downto 18);
                                 decoded_inst <= I_ADD_STORE;
                                 
                              when others =>
                                 decoded_inst <= I_NOP;
                           end case;     
                        end process;
   entrada_memoria <= "0000000000000000" & a_operand;
end architecture rtl;