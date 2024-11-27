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
max_allowed EQU 20
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

; Beginning Screen
enter_name BYTE "Enter Your Name: ", 0

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

program_exiting BYTE "Program is exiting. Thank you for playing. ",0

enter_guess_game_msg BYTE "=> Enter a number from 1-10: ", 0
win_guess_game_msg BYTE "You won, Congratulations. You get $2.", 0ah, 0dh, 0
lose_guess_game_msg BYTE "You lost loser. You lost $1. ", 0
correct_answer_guess_game_msg BYTE "The correct answer was: ",0
win_money_overflow_msg BYTE "You won, But your money is going to overflow the max. So your new balance is $20", 0ah, 0dh, 0
out_of_money_msg BYTE "You ran out of money. Please add some more to your account before you play a game.", 0

ask_to_play_again_msg BYTE 0ah, 0dh, "Would you like to play again? Remember: 99% of gamblers quit before they hit BIG!", 0ah, 0dh 
    BYTE "Enter 1 for yes and 0 for no: ", 0

play_again_input DWORD 0

stats_credit_msg BYTE "Available Credit: ", 0
stats_game_played_msg BYTE "Games Played: ", 0
stats_correct_guesses_msg BYTE "Correct Guesses: ", 0
stats_missed_guesses_msg BYTE "Missed Guesses: ", 0
stats_money_won_msg BYTE "Money you won: ", 0
stats_money_lost_msg BYTE "Money you lost: ", 0

please_choose_an_option_msg BYTE "Please choose a correct option", 0

overflow_msg BYTE "Error: The max allowed balance is $20", 0ah, 0dh
    BYTE "=> Your number is too big. Please try again.", 0ah, 0dh, 0

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

    ; Print 3 newlines
    call crlf
    call crlf
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
    JE call_play_game
    
    mov eax, 4
    CMP eax, input
    JE display_statistics

    mov eax, 5
    CMP eax, input
    JE exit_game

    mov eax, yellow + (black * 16)
    call SetTextcolor 
    mov edx, OFFSET please_choose_an_option_msg
    call writeString
    mov eax, white + (black * 16)
    call SetTextcolor
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
    mov eax, 0 ; Reset the eax to 0
    add eax, balance 			; Add the balance to the eax
    mov amount, 0                 ; Reset the amount to 0
    add amount, eax             ; Add the balance to the amount
    mov edx, OFFSET add_credits_text  ; Display message asking for credit
    call WriteString
    call ReadInt                    ; Read user input (the amount to add)
    add amount, eax                 ; Update the balance
    CMP amount, max_allowed         ; Check if the amount is greater than the max allowed
    JG overflow  ; If it is, jump to overflow
    mov eax, amount                ; Move the amount to eax
    mov balance, eax                ; Add the amount to the balance
    JMP continue                     ; Continue execution

overflow: ; If the amount is greater than the max allowed
    mov eax, red + (black * 16)
    call SetTextcolor 
    mov edx, OFFSET overflow_msg
    call WriteString
    mov eax, white + (black * 16)
    call SetTextcolor
    JMP add_credits

call_play_game:
    call PlayGame
    JMP continue

display_statistics: ; menu option 4
    call crlf
    mov edx, OFFSET player_name
    call WriteString
    call crlf
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
    mov edx, OFFSET program_exiting
    call WriteString
    exit

continue:
    call crlf
    call crlf
    call crlf
    JMP menu

main endp

; -------------------------
; PlayGame:   runs the main game logic
; Receives:       money_won, money_lost, games_played, missed_guesses, correct_guesses, balance, play_again_input
; Returns:        nothing
; Requires:       balance, RandomRange, writeString, ReadInt, WriteInt, Crlf, SetTextcolor, enter_guess_game_msg, please_choose_an_option_msg, lose_guess_game_msg, correct_answer_guess_game_msg, win_guess_game_msg, out_of_money_msg, and ask_to_play_again_msg
; -------------------------
PlayGame proc

start_of_play_game:

    CMP balance, 0
    JLE out_of_money
    dec balance
    mov eax, 9
    call RandomRange
    call Crlf
    mov correct_answer, eax
    add correct_answer, 1
    mov edx, OFFSET enter_guess_game_msg
    call writeString
    call ReadInt

    CMP eax, 0
    JLE bad_input
    CMP eax, 11
    JGE bad_input

    CMP eax, correct_answer
    JE win_game
    JMP lose_game

bad_input:
    mov eax, yellow + (black * 16)
    call SetTextcolor 
    mov edx, OFFSET please_choose_an_option_msg
    call writeString
    mov eax, white + (black * 16)
    call SetTextcolor
    JMP start_of_play_game

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
    CMP balance, 19
    JGE win_game_overflow
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

win_game_overflow:
    mov eax, green + (black * 16)
    call SetTextcolor 
    add money_won, 1
    mov edx, OFFSET win_money_overflow_msg
    call writeString
    mov balance, 20
    add games_played, 1
    add correct_guesses, 1
    mov eax, white + (black * 16)
    call SetTextcolor 
    JMP play_again

out_of_money:
    mov eax, yellow + (black * 16)
    call SetTextcolor 
    mov edx, OFFSET out_of_money_msg
    call writeString
    call crlf
    mov eax, white + (black * 16)
    call SetTextcolor 
    RET

play_again:
    CMP balance, 0
    JLE out_of_money
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
    JE start_of_play_game
    RET

PlayGame endp

end main
