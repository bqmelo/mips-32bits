library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
library mito;
use mito.mito_pkg.all;

entity control_unit is
    Port ( 

        clk                 : in  std_logic;
        rst_n               : in  std_logic;
        adress_sel           : out std_logic;
        pc_en               : out std_logic;
        ir_en               : out std_logic;
        data_en             : out std_logic;
        write_reg_en        : out std_logic;
        jmp_sel             : out std_logic;
        alu_mem_sel         : out std_logic;
        write_mem_en        : out std_logic;
        mem_write_sel       : out std_logic;
        alu_a_sel           : out std_logic;
        flag_z              : in  std_logic;
        flag_n              : in std_logic;
        decoded_inst        : in  decoded_instruction_type;
        alu_op              : out std_logic_vector(5 downto 0)
       
    );
end control_unit;


architecture rtl of control_unit is

    type state_type is(busca_inst, decodifica_inst, executa_inst, escreve_reg, prox_inst, fim_beq, jump_inst, escreve_mem, add_mem, add_result);
    signal current : state_type; 
    signal nextstate : state_type;

begin
    
    main : process(clk)
             begin
                 if (clk'event and clk ='1') then
                    if(rst_n ='1') then
                        current <= busca_inst;
                    else
                        current <= nextstate;
                    end if;
                 end if;
     end process main;
     
     
     next_state : process(current, decoded_inst, flag_z)
             begin
                        pc_en          <= '0';
                        alu_mem_sel    <= '0';
                        ir_en          <= '0';
                        write_reg_en   <= '0';
                        jmp_sel        <= '0';
                        write_mem_en   <= '0';
                        adress_sel     <= '0';
                        mem_write_sel  <= '0';
                        alu_a_sel      <= '0';
                        
                                           
                case current is
                   when busca_inst =>
                        alu_op         <= "000100";
                        ir_en          <= '1';
                        nextstate <= decodifica_inst;
               
                   when decodifica_inst =>
                       nextstate <= executa_inst;
                   
                   when executa_inst =>
                       case decoded_inst is
                           when I_LOAD =>
                               alu_mem_sel    <= '1';
                               adress_sel     <= '1';
                               write_reg_en   <= '1';
                               nextstate      <= prox_inst;
                               
                            when I_LW_ADD =>
                               alu_mem_sel    <= '1';
                               adress_sel     <= '1';
                               alu_a_sel      <= '1';
                               nextstate      <= add_mem;
                               
                            when I_STORE => 
                               write_mem_en   <= '1';
                               adress_sel     <= '1';
                               nextstate      <= escreve_mem;
                               
                            when I_ADD_STORE =>
                               alu_op         <= "000100";
                               write_reg_en   <= '1';
                               nextstate      <= add_result;
                               
                            when I_ADD => 
                               alu_op         <= "000100"; 
                               nextstate      <= escreve_reg;
                               
                            when I_SUB => 
                               alu_op         <= "000001";
                               nextstate      <= escreve_reg;
                               
                            when I_AND => 
                               alu_op         <= "000011";
                               nextstate      <= escreve_reg;
                               
                            when I_OR => 
                               alu_op         <= "000010";
                               nextstate      <= escreve_reg;
                               
                            when I_JMP => 
                               jmp_sel        <= '1';
                               pc_en          <= '1';
                               nextstate      <= jump_inst;
                               
                            when I_BEQ => 
                               alu_op         <= "000001";
                               nextstate      <= fim_beq;
                            
                            when I_NOP => 
                               nextstate      <= prox_inst; 
                                                       
                            when others =>
                               nextstate      <= prox_inst;
                       end case;
    
                   when add_mem =>
                       alu_a_sel      <= '1';
                       adress_sel     <= '1';
                       alu_op         <= "000100";
                       write_reg_en   <= '1'; 
                       nextstate      <= prox_inst;
                   
                   when add_result =>
                       nextstate      <= escreve_mem;
                            
                   when escreve_mem =>
                       write_mem_en   <= '1';
                       adress_sel     <= '1';
                       nextstate      <= prox_inst;
                           
                   when jump_inst =>
                       nextstate <= busca_inst;
                                                                       
                   when escreve_reg =>
                       ir_en          <= '0';
                       write_reg_en   <= '1';
                       nextstate      <= prox_inst;
                   
                   when fim_beq =>
                        if (flag_z = '1') then
                            jmp_sel   <= '1';
                            pc_en     <= '1';
                            nextstate <= jump_inst;
                       else
                            nextstate <= prox_inst;
                       end if;                  
                       
                   when prox_inst => -- Fim da maquina de estados
                       pc_en          <= '1';
                       nextstate      <= busca_inst;
         
                   when others =>
                       nextstate      <= busca_inst;
                end case;
    end process next_state;
end rtl;