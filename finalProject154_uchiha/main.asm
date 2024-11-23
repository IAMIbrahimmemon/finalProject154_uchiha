; --------------------------
; CMPR 154 - #42666
; Team Name: uchiha
; Team Member Names: Ibrahim Memon, Omar Hboubti, Areeb Sheikh, Tijany Momoh
; Creation Date: 10/30/2024
; Collaboration: Ibrahim, Omar, Areeb, Tijany Momoh, Professor
; --------------------------


INCLUDE Irvine32.inc

.data

; general data
balance DWORD 0 
MAX_ALLOWED DWORD 20
amount DWORD 0
correct_guesses DWORD 0
missed_guesses DWORD 0
games_played DWORD 0
player_name BYTE 101 DUP(?) ; For storing the name
money_won DWORD ?
money_lost DWORD ?

; utility variables
input DWORD 0
enteredText BYTE 101 DUP(?) ; For temporary user input
newline BYTE 0Dh, 0Ah, 0


; Beginning Screen
enter_name BYTE "Enter Your Name", 0dh, 0ah, 0dh, 0ah


; strings for display
menu_text BYTE "*** Uchiha ***", 0dh, 0ah, 0dh, 0ah
	 BYTE "*** MAIN MENU ***", 0dh, 0ah, 0dh, 0ah
	 BYTE "Please Select one of the following:", 0dh, 0ah, 0dh, 0ah
	 BYTE "1. Display my available credit", 0dh, 0ah
	 BYTE "2. Add credits to my account", 0dh, 0ah
	 BYTE "3. Play the guessing game", 0dh, 0ah
	 BYTE "4. Display my statistics", 0dh, 0ah
	 BYTE "5. To exit", 0dh, 0ah, 0

current_balance_text BYTE "=> Your available balance is: $ ", 0

add_credits_text BYTE "=> Please enter the amount you would like to add: ", 0

program_continued BYTE " ", 0ah, 0dh, 0

program_exiting BYTE "Program is exiting. Thank you for playing. ",0

enter_guess_game_msg BYTE "=> Enter a number from 1-10: ", 0
win_guess_game_msg BYTE "You won, Congratulations. You get $2.", 0ah, 0dh, 0
lose_guess_game_msg BYTE "You lost loser. You lost $1. ", 0
correct_answer_guess_game_msg BYTE "The correct answer was: ",0

ask_to_play_again_msg BYTE 0ah, 0dh, "Would you like to play again? Remember: 99% of gamblers quit befor they hit BIG!", 0ah, 0dh 
	BYTE "Enter 1 for yes and 0 for no: ", 0

play_again_input DWORD 0

stats_credit_msg BYTE "Available Credit: ", 0
stats_game_played_msg BYTE "Games Played: ", 0
stats_correct_guesses_msg BYTE "Correct Guesses: ", 0
stats_missed_guesses_msg BYTE "Missed Guesses: ", 0
stats_money_won_msg BYTE "Money you won: ", 0
stats_money_lost_msg BYTE "Money you lost: ", 0

correct_answer DWORD 0

uchiha_title_msg BYTE "      ___           ___           ___                       ___           ___     ", 0ah, 0dh
	BYTE "     /\__\         /\  \         /\__\          ___        /\__\         /\  \    ", 0ah, 0dh
	BYTE "    /:/  /        /::\  \       /:/  /         /\  \      /:/  /        /::\  \   ", 0ah, 0dh
	BYTE "   /:/  /        /:/\:\  \     /:/__/          \:\  \    /:/__/        /:/\:\  \  ", 0ah, 0dh
	BYTE "  /:/  /  ___   /:/  \:\  \   /::\  \ ___      /::\__\  /::\  \ ___   /::\~\:\  \ ", 0ah, 0dh
	BYTE " /:/__/  /\__\ /:/__/ \:\__\ /:/\:\  /\__\  __/:/\/__/ /:/\:\  /\__\ /:/\:\ \:\__\", 0ah, 0dh
	BYTE " \:\  \ /:/  / \:\  \  \/__/ \/__\:\/:/  / /\/:/  /    \/__\:\/:/  / \/__\:\/:/  /", 0ah, 0dh
	BYTE "  \:\  /:/  /   \:\  \            \::/  /  \::/__/          \::/  /       \::/  / ", 0ah, 0dh
	BYTE "   \:\/:/  /     \:\  \           /:/  /    \:\__\          /:/  /        /:/  /  ", 0ah, 0dh
	BYTE "    \::/  /       \:\__\         /:/  /      \/__/         /:/  /        /:/  /   ", 0ah, 0dh
	BYTE "     \/__/         \/__/         \/__/                     \/__/         \/__/    ", 0ah, 0dh, 0ah, 0dh ,0



.code



main proc

mov eax, lightblue + (black * 16)
call SetTextcolor 

mov edx, OFFSET uchiha_title_msg
call writeString

mov eax, white + (black * 16)
call SetTextcolor 

	;asking player for name
	mov edx, OFFSET enter_name
	call WriteString   ; Display "Enter Your Name"

	; Input from user
	mov edx, OFFSET enteredText   ; Buffer for input
	mov ecx, SIZEOF enteredText   ; Max size (101 bytes)
	call ReadString               ; Read user input

	; Copy enteredText to player_name
	lea esi, enteredText          ; Source: enteredText
	lea edi, player_name          ; Destination: player_name
	mov ecx, SIZEOF enteredText   ; Copy all bytes (including null terminator)
	rep movsb                     ; Copy string to player_name

	; Print a newline
	mov edx, OFFSET newline
	call WriteString

	; Display entered name
	mov edx, OFFSET player_name
	call WriteString
	call crlf
	
		

menu:
	; display menu
	mov edx, OFFSET menu_text
	call writeString

	; collect user input
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

	display_balance: ; menu option 1
		mov edx, OFFSET current_balance_text ;Move the address of our "current balance text" to edx
		
		call WriteString
		mov eax, green + (black * 16)
		call SetTextcolor 
		mov eax, balance
		call WriteInt
		call crlf
		mov eax, white + (black * 16)
		call SetTextcolor 
		JMP continue

	add_credits: ; menu option 2
		mov edx, OFFSET add_credits_text
		call WriteString
		call ReadInt
		add balance, eax
		JMP continue

	play_game:	
		dec balance
		mov eax, 10
		;call RandomRange
		;call WriteDec
		;call Crlf
		mov correct_answer, eax
		mov edx, OFFSET enter_guess_game_msg
		call writeString
		call ReadInt
		CMP eax, correct_answer
		JE win_game
		JMP lose_game

	lose_game:
		mov eax, red + (black * 16)
		call SetTextcolor 
		add money_lost, 1
		mov edx, OFFSET lose_guess_game_msg
		call writeString
		mov edx, OFFSET correct_answer_guess_game_msg
		call writeString
		mov eax, correct_answer
		call WriteInt
		call crlf
		add games_played, 1
		add missed_guesses, 1
		mov eax, white + (black * 16)
		call SetTextcolor 
		JMP play_again

	win_game:
		mov eax, green + (black * 16)
		call SetTextcolor 
		add money_won, 2
		mov edx, OFFSET win_guess_game_msg
		call writeString
		add balance, 2
		add games_played, 1
		add correct_guesses, 1
		mov eax, white + (black * 16)
		call SetTextcolor 
		JMP play_again

	play_again:
		mov eax, yellow + (black * 16)
		call SetTextcolor 
		mov edx, OFFSET ask_to_play_again_msg
		call writeString


		call ReadInt
		mov play_again_input, eax

		mov eax, white + (black * 16)
		call SetTextcolor 

		mov eax, 1 
		CMP eax, play_again_input
		JE play_game
		JMP continue

	display_statistics: ; menu option 4
		
		mov edx, OFFSET player_name
		call WriteString
		mov edx, OFFSET newline
		call WriteString
		mov eax, yellow + (black * 16)
		call SetTextcolor 
		mov edx, OFFSET stats_credit_msg
		call WriteString
		mov eax, balance
		call WriteInt
		call crlf
		mov edx, OFFSET stats_game_played_msg
		call WriteString
		mov eax, games_played
		call WriteInt
		call crlf
		mov eax, green + (black * 16)
		call SetTextcolor 
		mov edx, OFFSET stats_correct_guesses_msg
		call WriteString
		mov eax, correct_guesses
		call WriteInt
		call crlf
		mov eax, red + (black * 16)
		call SetTextcolor 
		mov edx, OFFSET stats_missed_guesses_msg
		call WriteString
		mov eax, missed_guesses
		call WriteInt
		call crlf
		mov eax, green + (black * 16)
		call SetTextcolor 
		mov edx, OFFSET stats_money_won_msg
		call WriteString
		mov eax, money_won
		call WriteInt
		call crlf
		mov eax, red + (black * 16)
		call SetTextcolor 
		mov edx, OFFSET stats_money_lost_msg
		call WriteString
		mov eax, money_lost
		call WriteInt
		call crlf
		mov eax, white + (black * 16)
		call SetTextcolor 
		JMP continue

	exit_game:
		exit

	continue:
		mov edx, OFFSET program_continued 
		call WriteString
		call crlf
		JMP menu

	go_to_exit: 
		mov edx, OFFSET program_exiting
		call WriteString
		exit
main endp
end main
