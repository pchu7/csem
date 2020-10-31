	.text
	.file	"<stdin>"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	movl	%edi, -4(%rsp)
	cmpl	$14, %edi
	jg	.LBB0_2
# %bb.1:                                # %L0
	movl	$88, %eax
	retq
.LBB0_2:                                # %L1
	movl	$21, %eax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
