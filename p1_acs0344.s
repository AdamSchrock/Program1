.global main
.func main
   
main:
    BL  _promptval             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R5, R0              @ move return value R0 to argument register R1
    BL  _promptop
    BL  _getchar            @ branch to scanf procedure with return
    MOV R4, R0
    BL  _promptval
    BL  _scanf
    MOV R6, R0

    MOV R1, R4
    BL _compareplus


    BL  _printf             @ branch to print procedure with return
    B   _exit               @ branch to exit procedure with no return
   


_promptval:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_promptop:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =promptop_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return
    
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compareplus:
    CMP R1, #'+'        
    BEQ _add            
    BNE _compareminus

_compareminus:
    CMP R1, #'-'           
    BEQ _subtract       
    BNE _comparemultiply

_comparemultiply:
    CMP R1, #'*'           
    BEQ _multiply       
    BNE _comparemax

_comparemax:
    CMP R1, #'M'           
    BEQ _max      
    BNE _invalid

_invalid:
    MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =nequal_str     @ R0 contains formatted string address
    BL printf               @ call printf
    MOV PC, R5              @ return

_add
    ADD R1, R5, R6

_substract
    SUB R1, R5, R6

_multiply
    MUL R1, R5, R6

_max
    MOV R0, R5
    MOV R1, R6
    CMP R0, R1
    MOVGT R1, R0

    
      


.data
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Operand: "
promptop_str:   .asciz      "Operator: "
read_char:      .ascii      " "
nequal_str:     .asciz      "INVALID OPERATOR: %c \n"
printf_str:     .asciz      "Answer: %d\n"