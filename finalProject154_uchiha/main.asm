INCLUDE Irvine32.inc

.data
balance DWORD 0
MAX_ALLOWED DWORD 20
amount DWORD 0
correctGuesses DWORD 0
missedGuesses DWORD 0
name DWORD 15 DUP(?)

menu_text BYTE "*** Uchiha ***", 0dh, 0ah, 0dh, 0ah
	 BYTE "*** MAIN MENU ***", 0dh, 0ah, 0dh, 0ah
	 BYTE "Please Select one of the following:", 0dh, 0ah, 0dh, 0ah
	 BYTE "1. Display my available credit", 0dh, 0ah
	 BYTE "2. Add credits to my account", 0dh, 0ah
	 BYTE "3. Play the guessing game", 0dh, 0ah
	 BYTE "4. Display my statistics", 0dh, 0ah
	 BYTE "5. To exit", 0dh, 0ah, 0

input DWORD ?

current_balance_text BYTE "=> Your available balance is: $ ", 0
add_credits_text BYTE "=> Please enter the amount you would like to add: ", 0

program_continuesd BYTE "=> Program Contirnuesd", 0

.code
main proc

start:
	mov edx, OFFSET menu_text
	call writeString
	call ReadInt

	mov input, eax
	mov eax, 1
	CMP eax, input
	JE display_balance
	
	mov eax, 2
	CMP eax, input
	JE add_credits

	mov eax, 3
	CMP eax, input
	JE play_game

	mov eax, 4
	CMP eax, input
	JE display_statistics

	mov eax, 5
	CMP eax, input
	JE exit_game

	JMP continue

	display_balance:
		mov edx, OFFSET current_balance_text
		call WriteString
		mov eax, balance
		call WriteInt
		call crlf
		JMP continue

	add_credits:
		mov edx, OFFSET add_credits_text
		call WriteString
		call ReadInt
		add balance, eax
		JMP continue

	play_game:
		JMP continue

	display_statistics:
		JMP continue

	exit_game:
		JMP continue

	continue:
		mov edx, OFFSET program_continuesd
		call WriteString
		call crlf
		JMP start

	exit
main endp

end main