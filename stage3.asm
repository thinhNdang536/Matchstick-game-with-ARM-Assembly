  1|// Messager registers
  2|; R3: Message pointer
  3|// Variable registers
  4|; R8: Turn (0: human, 1: computer)
  5|; R11: player's name
  6|; R12: remain matchstick number
  7|playAgain:
  8|      MOV R8, #0
  9|      MOV R3, #inputMsg1 ; Prompt for player name
 10|      STR R3, .WriteString
 11|      MOV R11, #playerName ; Reserve space for name input
 12|      STR R11, .ReadString ; Read player name
 13|// Get matchstick number
 14|getMatchstick:
 15|      MOV R3, #inputMsg2 ; Prompt for matchstick number
 16|      STR R3, .WriteString
 17|      LDR R12, .InputNum ; Read matchstick number
 18|      CMP R12, #10      ; Check if < 10
 19|      BLT invalidMatchstick
 20|      CMP R12, #100     ; Check if > 100
 21|      BGT invalidMatchstick
 22|      B displayInfo
 23|// Invalid matchstick number
 24|invalidMatchstick:
 25|      MOV R3, #errorMsg1 ; Show error message
 26|      STR R3, .WriteString
 27|      B getMatchstick
 28|// Display game info
 29|displayInfo:
 30|      MOV R3, #outputMsg1
 31|      STR R3, .WriteString ; Display message
 32|      MOV R3, R11       ; Display player name
 33|      STR R3, .WriteString
 34|      MOV R3, #newLine
 35|      STR R3, .WriteString
 36|      MOV R3, #outputMsg2
 37|      STR R3, .WriteString ; Display matchstick count
 38|      MOV R3, R12
 39|      STR R3, .WriteUnsignedNum
 40|      MOV R3, #newLine
 41|      STR R3, .WriteString
 42|// Show remain matchstick number
 43|remainMatchstick:
 44|      MOV R3, #outputMsg3
 45|      STR R3, .WriteString
 46|      MOV R3, R11       ; load player's name from R11
 47|      STR R3, .WriteString
 48|      MOV R3, #outputMsg4
 49|      STR R3, .WriteString
 50|      MOV R3, R12       ; load matchstick number from R12
 51|      CMP R12, #0
 52|      BEQ noRemainDisplay ; if zero, print "no more remain"
 53|      BLT noRemainDisplay ; if negative, print "no more remain"
 54|      STR R3, .WriteUnsignedNum
 55|      B remainContDisplay
 56|// Ensure not to display non-zero and non-negative matchstick number
 57|noRemainDisplay:
 58|      MOV R3, #outputMsg5 ; load "no" string to display
 59|      STR R3, .WriteString
 60|// Continue to display matchstick number
 61|remainContDisplay:
 62|      MOV R3, #outputMsg6
 63|      STR R3, .WriteString
 64|      STR R3, .ClearScreen 
 65|      CMP R12, #0
 66|      BEQ gameDraw      ; if no matchsticks left, draw
 67|      BLT gameDraw      ; if negative, draw
 68|      CMP R12, #1
 69|      BEQ gameResult    ; if 1 matchstick remains, return game result based on player's turn
 70|      CMP R8, #0
 71|      BEQ getRemoveMatchstick
 72|      CMP R8, #1
 73|      BEQ computerTurn
 74|// Human's turn
 75|// Get matchstick number to remove
 76|getRemoveMatchstick:
 77|      MOV R8, #1        ; 0 = human's turn
 78|      MOV R3, #outputMsg10
 79|      STR R3, .WriteString
 80|      MOV R3, #outputMsg3
 81|      STR R3, .WriteString
 82|      MOV R3, R11       ; load player's name from R11
 83|      STR R3, .WriteString
 84|      MOV R3, #outputMsg7
 85|      STR R3, .WriteString
 86|      LDR R4, .InputNum ; Read matchstick number to remove
 87|      CMP R4, #1        ; Check if < 1, true => raise invalid_matchstick_number_to_remove error
 88|      BLT invalidNum2Remove
 89|      CMP R4, #7        ; Check if > 7, true => raise invalid_matchstick_number_to_remove error
 90|      BGT invalidNum2Remove
 91|      MOV R3, #outputMsg11
 92|      STR R3, .WriteString
 93|      MOV R3, R4        ; load matchstick number to remove from R4
 94|      STR R3, .WriteUnsignedNum
 95|      MOV R3, #outputMsg12
 96|      STR R3, .WriteString
 97|      SUB R12, R12, R4  ; Valid input => subtract matchstick number
 98|      B remainMatchstick
 99|// Computer's turn
100|computerTurn:
101|      MOV R8, #0        ; 1 = computer's turn
102|      MOV R3, #outputMsg8
103|      STR R3, .WriteString
104|      LDR R4, .Random   ; get random matchsticks number for computer player
105|      AND R4, R4, #6    ; limit matchstick number at 6 (0-6)
106|      ADD R4, R4, #1    ; plus 1 to limit matchstick from 1 to 7
107|      MOV R3, #outputMsg9
108|      STR R3, .WriteString
109|      MOV R3, R4        ; load random matchstick number from R4
110|      STR R3, .WriteUnsignedNum
111|      MOV R3, #outputMsg12
112|      STR R3, .WriteString
113|      SUB R12, R12, R4  ; Valid input => subtract matchstick number
114|      B remainMatchstick
115|// Invalid matchstick to remove
116|invalidNum2Remove:
117|      MOV R3, #errorMsg2
118|      STR R3, .WriteString
119|      B getRemoveMatchstick ; ask for valid input again
120|// Return game result based on player's turn
121|gameResult:
122|      MOV R3, #outputMsg13
123|      STR R3, .WriteString
124|      MOV R3, #outputMsg3
125|      STR R3, .WriteString
126|      MOV R3, R11       ; load player's name from R11
127|      STR R3, .WriteString
128|      CMP R8, #1
129|      BEQ gameWin
130|      CMP R8, #0
131|      BEQ gameLose
132|// Return win result [matchstick (R7) = 1, turn (R8) = 0]
133|gameWin:
134|      MOV R3, #outputMsg14
135|      STR R3, .WriteString
136|      B askDecision
137|// Return lose result [matchstick (R7) = 1, turn (R8) = 1]
138|gameLose:
139|      MOV R3, #outputMsg15
140|      STR R3, .WriteString
141|      B askDecision
142|// Return draw result [matchstick (R7) <= 0]
143|gameDraw:
144|      MOV R3, #outputMsg13
145|      STR R3, .WriteString
146|      STR R3, .ClearScreen
147|      MOV R3, #outputMsg16
148|      STR R3, .WriteString
149|      B askDecision
150|// Ask player for decision after game ends
151|askDecision:
152|      MOV R3, #inputMsg3
153|      STR R3, .WriteString
154|      MOV R4, #playerDecision
155|      STR R4, .ReadString ; read and store player's decision after game ends
156|      LDRB R4, [R4]
157|      CMP R4, #121      ; 121 is the ASCII number for "y"
158|      BEQ playAgain
159|      CMP R4, #110      ; 110 is the ASCII number for "n"
160|      BEQ gameEnd
161|      B invalidDecision
162|// Invalid decision
163|invalidDecision:
164|      MOV R3, #errorMsg3
165|      STR R3, .WriteString
166|      B askDecision     ; ask for valid input again
167|// Completely end game
168|gameEnd:
169|      HALT
170|// Spaces
171|newLine: .ASCIZ "\n"    ; New line character
172|playerName: .BLOCK 128  ; Reserved space for player name
173|playerDecision: .BLOCK 128 ; Reserved space for player decision
174|// Input Messages
175|inputMsg1: .ASCIZ "Please enter your name:\n"
176|inputMsg2: .ASCIZ "How many matchsticks (10-100)?\n"
177|inputMsg3: .ASCIZ "Play again (y/n)?\n\n"
178|// Error Messages
179|errorMsg1: .ASCIZ "Invalid input! Please enter a number between 10 and 100.\n"
180|errorMsg2: .ASCIZ "Invalid input! Please enter a number between 0 and 7.\n"
181|errorMsg3: .ASCIZ "Invalid input! Please enter yes(y) or no(n) decision.\n"
182|// Output Messages
183|outputMsg1: .ASCIZ "\nPlayer 1 is: "
184|outputMsg2: .ASCIZ "Matchsticks: "
185|outputMsg3: .ASCIZ "\nPlayer "
186|outputMsg4: .ASCIZ ", there are "
187|outputMsg5: .ASCIZ "no more "
188|outputMsg6: .ASCIZ "matchsticks remaining."
189|outputMsg7: .ASCIZ ", how many do you want to remove (1-7)?\n"
190|outputMsg8: .ASCIZ "\nComputer’s turn!\n"
191|outputMsg9: .ASCIZ "Computer chose to remove "
192|outputMsg10: .ASCIZ "\nYour turn!"
193|outputMsg11: .ASCIZ "You chose to remove "
194|outputMsg12: .ASCIZ "matchsticks.\n"
195|outputMsg13: .ASCIZ "\n\nGame over!"
196|outputMsg14: .ASCIZ ", YOU WIN!\n"
197|outputMsg15: .ASCIZ ", YOU LOSE!\n"
198|outputMsg16: .ASCIZ "\nIt’s a draw!\n"
