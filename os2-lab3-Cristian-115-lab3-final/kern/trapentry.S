/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

    TRAPHANDLER_NOEC(TRAP_HANDLER_1 ,T_DIVIDE)
    TRAPHANDLER_NOEC(TRAP_HANDLER_2,T_DEBUG)
    TRAPHANDLER_NOEC(TRAP_HANDLER_3,T_BRKPT)
    TRAPHANDLER_NOEC(TRAP_HANDLER_4,T_OFLOW)
    TRAPHANDLER_NOEC(TRAP_HANDLER_5,T_BOUND)
    TRAPHANDLER_NOEC(TRAP_HANDLER_6,T_ILLOP)
    TRAPHANDLER_NOEC(TRAP_HANDLER_7,T_DEVICE)
    TRAPHANDLER(TRAP_HANDLER_8,T_DBLFLT)
    TRAPHANDLER_NOEC(TRAP_HANDLER_9,T_TSS)
    TRAPHANDLER(TRAP_HANDLER_10,T_SEGNP)
    TRAPHANDLER(TRAP_HANDLER_11,T_STACK)
    TRAPHANDLER(TRAP_HANDLER_12,T_GPFLT)
    TRAPHANDLER(TRAP_HANDLER_13,T_PGFLT)
    TRAPHANDLER_NOEC(TRAP_HANDLER_14,T_FPERR)
    TRAPHANDLER_NOEC(TRAP_HANDLER_15, T_NMI)
    TRAPHANDLER_NOEC(TRAP_HANDLER_16, T_ALIGN)
    TRAPHANDLER_NOEC(TRAP_HANDLER_17, T_MCHK)
    TRAPHANDLER_NOEC(TRAP_HANDLER_18, T_SIMDERR)
    TRAPHANDLER_NOEC(TRAP_HANDLER_19,T_SYSCALL)
// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not..

    _alltraps:
    pushl %ds
    pushl %es
    pushal

    movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es
    pushl %esp
    call trap


