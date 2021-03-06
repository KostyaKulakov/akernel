/* The sole purpose of this file is to initialize processor and get ready to execute C program.
 *
 * _start is a kernel entry point. It copies interrupt table to the right place, initializes hypervisor and
 * irq stacks and transfers control to main() function.
 */
.global _start
_start:
	mov r0, #0x00
	ldr r1, =interrupt_table
	ldr r3, =interrupt_table_end
keep_loading:
	ldr r2, [r1, #0x0]
	str r2, [r0, #0x0]
	add r0, r0, #0x4
	add r1, r1, #0x4
	cmp r1, r3
	bne keep_loading

	msr CPSR_c, #0xD2 /* IRQ mode */
	ldr sp, =irq_stack+8192

	msr CPSR_c, #0xD3 /* Hypervisor mode */
	ldr sp, =hyp_stack+8192
	bl main

interrupt_table:
	nop /* 0 */
	nop
	ldr pc, svc_entry_address
	nop
	nop /* 5 */
	nop
	ldr pc, irq_entry_address

	svc_entry_address: .word svc_entry
	irq_entry_address: .word irq_entry
interrupt_table_end:
