  1|// Messager registers
  2|; R3: Message pointer
  3|// Variable registers
  4|; R11: player's name
  5|; R12: remain matchstick number
  6|      MOV R3, #inputMsg1 ; Prompt for player name
  7|      STR R3, .WriteString
  8|      MOV R11, #playerName ; Reserve space for name input
  9|      STR R11, .ReadString ; Read player name
 10|// Get matchstick number
 11|getMatchstick:
 12|      MOV R3, #inputMsg2 ; Prompt for matchstick number
 13|      STR R3, .WriteString
 14|      LDR R12, .InputNum ; Read matchstick number
 15|      CMP R12, #10      ; Check if < 10
 16|      BLT invalidMatchstick
 17|      CMP R12, #100     ; Check if > 100
 18|      BGT invalidMatchstick
 19|      B displayInfo
 20|// Invalid matchstick number
 21|invalidMatchstick:
 22|      MOV R3, #errorMsg1 ; Show error message
 23|      STR R3, .WriteString
 24|      B getMatchstick
 25|// Display game info
 26|displayInfo:
 27|      MOV R3, #outputMsg1
 28|      STR R3, .WriteString ; Display message
 29|      MOV R3, R11       ; Display player name
 30|      STR R3, .WriteString
 31|      MOV R3, #newLine
 32|      STR R3, .WriteString
 33|      MOV R3, #outputMsg2
 34|      STR R3, .WriteString ; Display matchstick count
 35|      MOV R3, R12
 36|      STR R3, .WriteUnsignedNum
 37|      MOV R3, #newLine
 38|      STR R3, .WriteString
 39|// Show remain matchstick number
 40|remainMatchstick:
 41|      MOV R4, #0        ; Initialize pixel location
 42|      MOV R5, #0        ; Initialize matchstick counter
 43|      MOV R7, #10       ; Set line break after 10 matchsticks
 44|      ADD R4, R4, #268  ; Set first matchstick position (pixel 67)
 45|      MOV R3, #outputMsg3
 46|      STR R3, .WriteString
 47|      MOV R3, R11       ; load player's name from R11
 48|      STR R3, .WriteString
 49|      MOV R3, #outputMsg4
 50|      STR R3, .WriteString
 51|      MOV R3, R12       ; load matchstick number from R12
 52|      CMP R12, #0
 53|      BEQ noRemainDisplay ; if zero, print "no more remain"
 54|      BLT noRemainDisplay ; if negative, print "no more remain"
 55|      STR R3, .WriteUnsignedNum
 56|      B remainContDisplay
 57|// Ensure not to display non-zero and non-negative matchstick number
 58|noRemainDisplay:
 59|      MOV R3, #outputMsg5 ; load "no" string to display
 60|      STR R3, .WriteString
 61|// Continue to display matchstick number
 62|remainContDisplay:
 63|      MOV R3, #outputMsg6
 64|      STR R3, .WriteString
 65|      STR R3, .ClearScreen 
 66|      CMP R12, #0
 67|      BEQ gameEnd       ; if no matchsticks left, game over
 68|      BLT gameEnd       ; if negative, game over
 69|// Human's turn
 70|// Get matchstick number to remove
 71|getRemoveMatchstick:
 72|      MOV R8, #1        ; 0 = human's turn
 73|      MOV R3, #outputMsg8
 74|      STR R3, .WriteString
 75|      MOV R3, #outputMsg3
 76|      STR R3, .WriteString
 77|      MOV R3, R11       ; load player's name from R11
 78|      STR R3, .WriteString
 79|      MOV R3, #outputMsg7
 80|      STR R3, .WriteString
 81|      LDR R4, .InputNum ; Read matchstick number to remove
 82|      CMP R4, #1        ; Check if < 1, true => raise invalid_matchstick_number_to_remove error
 83|      BLT invalidNum2Remove
 84|      CMP R4, #7        ; Check if > 7, true => raise invalid_matchstick_number_to_remove error
 85|      BGT invalidNum2Remove
 86|      MOV R3, #outputMsg9
 87|      STR R3, .WriteString
 88|      MOV R3, R4        ; load matchstick number to remove from R4
 89|      STR R3, .WriteUnsignedNum
 90|      MOV R3, #outputMsg10
 91|      STR R3, .WriteString
 92|      SUB R12, R12, R4  ; Valid input => subtract matchstick number
 93|      B remainMatchstick
 94|// Invalid matchstick to remove
 95|invalidNum2Remove:
 96|      MOV R3, #errorMsg2
 97|      STR R3, .WriteString
 98|      B getRemoveMatchstick ; ask for valid input again
 99|// Completely end game
100|gameEnd:
101|      MOV R3, #outputMsg11
102|      STR R3, .WriteString
103|      HALT
104|// Spaces
105|newLine: .ASCIZ "\n"    ; New line character
106|playerName: .BLOCK 128  ; Reserved space for player name
107|playerDecision: .BLOCK 128 ; Reserved space for player decision
108|// Input Messages
109|inputMsg1: .ASCIZ "Please enter your name:\n"
110|inputMsg2: .ASCIZ "How many matchsticks (10-100)?\n"
111|inputMsg3: .ASCIZ "Play again (y/n)?\n\n"
112|// Error Messages
113|errorMsg1: .ASCIZ "Invalid input! Please enter a number between 10 and 100.\n"
114|errorMsg2: .ASCIZ "Invalid input! Please enter a number between 0 and 7.\n"
115|// Output Messages
116|outputMsg1: .ASCIZ "\nPlayer 1 is: "
117|outputMsg2: .ASCIZ "Matchsticks: "
118|outputMsg3: .ASCIZ "\nPlayer "
119|outputMsg4: .ASCIZ ", there are "
120|outputMsg5: .ASCIZ "no more "
121|outputMsg6: .ASCIZ "matchsticks remaining."
122|outputMsg7: .ASCIZ ", how many do you want to remove (1-7)?\n"
123|outputMsg8: .ASCIZ "\nYour turn!"
124|outputMsg9: .ASCIZ "You chose to remove "
125|outputMsg10: .ASCIZ "matchsticks.\n"
126|outputMsg11: .ASCIZ "\nGame over!"
