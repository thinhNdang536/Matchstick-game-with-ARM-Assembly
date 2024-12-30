  1|// Unchanged registers
  2|; R0: Pixel screen address
  3|; R1: Color (red)
  4|; R2: Color (burlywood)
  5|// Messager registers
  6|; R3: Message pointer
  7|// Variable registers
  8|; R4: Pixel location (matchstick position)
  9|; R5: Matchstick counter
 10|; R6: Matchstick body counter (burlywood)
 11|; R7: Line break counter (after 10 matchsticks)
 12|; R8: Turn (0: human, 1: computer)
 13|; R11: player's name
 14|; R12: remain matchstick number
 15|      MOV R0, #.PixelScreen
 16|      MOV R1, #.red
 17|      MOV R2, #.burlywood
 18|playAgain:
 19|      MOV R8, #0
 20|      STR R3, .ClearScreen
 21|      MOV R3, #inputMsg1 ; Prompt for player name
 22|      STR R3, .WriteString
 23|      MOV R11, #playerName ; Reserve space for name input
 24|      STR R11, .ReadString ; Read player name
 25|      B getMatchstick
 26|// Get matchstick number
 27|getMatchstick:
 28|      MOV R3, #inputMsg2 ; Prompt for matchstick number
 29|      STR R3, .WriteString
 30|      LDR R12, .InputNum ; Read matchstick number
 31|      CMP R12, #10      ; Check if < 10
 32|      BLT invalidMatchstick
 33|      CMP R12, #100     ; Check if > 100
 34|      BGT invalidMatchstick
 35|      B displayInfo
 36|// Invalid matchstick number
 37|invalidMatchstick:
 38|      MOV R3, #errorMsg1 ; Show error message
 39|      STR R3, .WriteString
 40|      B getMatchstick
 41|// Display game info
 42|displayInfo:
 43|      MOV R3, #outputMsg1
 44|      STR R3, .WriteString ; Display message
 45|      MOV R3, R11       ; Display player name
 46|      STR R3, .WriteString
 47|      MOV R3, #newLine
 48|      STR R3, .WriteString
 49|      MOV R3, #outputMsg2
 50|      STR R3, .WriteString ; Display matchstick count
 51|      MOV R3, R12
 52|      STR R3, .WriteUnsignedNum
 53|      MOV R3, #newLine
 54|      STR R3, .WriteString
 55|// Show remain matchstick number
 56|remainMatchstick:
 57|      MOV R4, #0        ; Initialize pixel location
 58|      MOV R5, #0        ; Initialize matchstick counter
 59|      MOV R7, #10       ; Set line break after 10 matchsticks
 60|      ADD R4, R4, #268  ; Set first matchstick position (pixel 67)
 61|      MOV R3, #outputMsg3
 62|      STR R3, .WriteString
 63|      MOV R3, R11       ; load player's name from R11
 64|      STR R3, .WriteString
 65|      MOV R3, #outputMsg4
 66|      STR R3, .WriteString
 67|      MOV R3, R12       ; load matchstick number from R12
 68|      CMP R12, #0
 69|      BEQ noRemainDisplay ; if zero, print "no more remain"
 70|      BLT noRemainDisplay ; if negative, print "no more remain"
 71|      STR R3, .WriteUnsignedNum
 72|      B remainContDisplay
 73|// Ensure not to display non-zero and non-negative matchstick number
 74|noRemainDisplay:
 75|      MOV R3, #outputMsg5 ; load "no" string to display
 76|      STR R3, .WriteString
 77|// Continue to display matchstick number
 78|remainContDisplay:
 79|      MOV R3, #outputMsg6
 80|      STR R3, .WriteString
 81|      STR R3, .ClearScreen
 82|      BL drawHead
 83|// Draw head part of matchstick
 84|drawHead:
 85|      MOV R6, #0        ; Reset body part counter
 86|      STR R1, [R0+R4]   ; Draw matchstick head (red)
 87|      B drawBody
 88|// Draw body part of matchstick
 89|drawBody:
 90|      ADD R4, R4, #4    ; Move to next body part position
 91|      STR R2, [R0+R4]
 92|      ADD R6, R6, #1    ; Increment body counter
 93|      CMP R6, #3        ; Check if body is fully drawn
 94|      BNE drawBody      ; Continue if not
 95|      ADD R5, R5, #1    ; Increment matchstick counter
 96|      CMP R5, R7        ; Check if 10 matchsticks reached
 97|      BEQ drawNewLine   ; If yes, break line
 98|      ADD R4, R4, #12   ; Move to next position without break line
 99|      B stopDraw
100|// Break into new line after drawing 10 matchsticks
101|drawNewLine:
102|      ADD R7, R7, #10   ; Update line counter
103|      ADD R4, R4, #1040 ; Move to next line
104|      ADD R4, R4, #12   ; Add spacing
105|      B stopDraw
106|// Stop draw and process game result base on remain matchstick number
107|stopDraw:
108|      CMP R5, R12       ; Check if all matchsticks are drawn
109|      BLT drawHead      ; Continue if not
110|      CMP R12, #0
111|      BEQ gameDraw      ; if no matchsticks left, draw
112|      BLT gameDraw      ; if negative, draw
113|      CMP R12, #1
114|      BEQ gameResult    ; if 1 matchstick remains, return game result based on player's turn
115|      CMP R8, #0
116|      BEQ getRemoveMatchstick
117|      CMP R8, #1
118|      BEQ computerTurn
119|// Human's turn
120|// Get matchstick number to remove
121|getRemoveMatchstick:
122|      MOV R8, #1        ; 0 = human's turn
123|      MOV R3, #outputMsg10
124|      STR R3, .WriteString
125|      MOV R3, #outputMsg3
126|      STR R3, .WriteString
127|      MOV R3, R11       ; load player's name from R11
128|      STR R3, .WriteString
129|      MOV R3, #outputMsg7
130|      STR R3, .WriteString
131|      LDR R4, .InputNum ; Read matchstick number to remove
132|      CMP R4, #1        ; Check if < 1, true => raise invalid_matchstick_number_to_remove error
133|      BLT invalidNum2Remove
134|      CMP R4, #7        ; Check if > 7, true => raise invalid_matchstick_number_to_remove error
135|      BGT invalidNum2Remove
136|      MOV R3, #outputMsg11
137|      STR R3, .WriteString
138|      MOV R3, R4        ; load matchstick number to remove from R4
139|      STR R3, .WriteUnsignedNum
140|      MOV R3, #outputMsg12
141|      STR R3, .WriteString
142|      SUB R12, R12, R4  ; Valid input => subtract matchstick number
143|      B remainMatchstick
144|// Computer's turn
145|computerTurn:
146|      MOV R8, #0        ; 1 = computer's turn
147|      MOV R3, #outputMsg8
148|      STR R3, .WriteString
149|      LDR R4, .Random   ; get random matchsticks number for computer player
150|      AND R4, R4, #6    ; limit matchstick number at 6 (0-6)
151|      ADD R4, R4, #1    ; plus 1 to limit matchstick from 1 to 7
152|      MOV R3, #outputMsg9
153|      STR R3, .WriteString
154|      MOV R3, R4        ; load random matchstick number from R4
155|      STR R3, .WriteUnsignedNum
156|      MOV R3, #outputMsg12
157|      STR R3, .WriteString
158|      SUB R12, R12, R4  ; Valid input => subtract matchstick number
159|      B remainMatchstick
160|// Invalid matchstick to remove
161|invalidNum2Remove:
162|      MOV R3, #errorMsg2
163|      STR R3, .WriteString
164|      B getRemoveMatchstick ; ask for valid input again
165|// Return game result based on player's turn
166|gameResult:
167|      MOV R3, #outputMsg13
168|      STR R3, .WriteString
169|      MOV R3, #outputMsg3
170|      STR R3, .WriteString
171|      MOV R3, R11       ; load player's name from R11
172|      STR R3, .WriteString
173|      CMP R8, #1
174|      BEQ gameWin
175|      CMP R8, #0
176|      BEQ gameLose
177|// Return win result [matchstick (R7) = 1, turn (R8) = 0]
178|gameWin:
179|      MOV R3, #outputMsg14
180|      STR R3, .WriteString
181|      B askDecision
182|// Return lose result [matchstick (R7) = 1, turn (R8) = 1]
183|gameLose:
184|      MOV R3, #outputMsg15
185|      STR R3, .WriteString
186|      B askDecision
187|// Return draw result [matchstick (R7) <= 0]
188|gameDraw:
189|      MOV R3, #outputMsg13
190|      STR R3, .WriteString
191|      STR R3, .ClearScreen
192|      MOV R3, #outputMsg16
193|      STR R3, .WriteString
194|      B askDecision
195|// Ask player for decision after game ends
196|askDecision:
197|      MOV R3, #inputMsg3
198|      STR R3, .WriteString
199|      MOV R4, #playerDecision
200|      STR R4, .ReadString ; read and store player's decision after game ends
201|      LDRB R4, [R4]
202|      CMP R4, #121      ; 121 is the ASCII number for "y"
203|      BEQ playAgain
204|      CMP R4, #110      ; 110 is the ASCII number for "n"
205|      BEQ gameEnd
206|      B invalidDecision
207|// Invalid decision
208|invalidDecision:
209|      MOV R3, #errorMsg3
210|      STR R3, .WriteString
211|      B askDecision     ; ask for valid input again
212|// Completely end game
213|gameEnd:
214|      STR R3, .ClearScreen
215|      HALT
216|// Spaces
217|newLine: .ASCIZ "\n"    ; New line character
218|playerName: .BLOCK 128  ; Reserved space for player name
219|playerDecision: .BLOCK 128 ; Reserved space for player decision
220|// Input Messages
221|inputMsg1: .ASCIZ "Please enter your name:\n"
222|inputMsg2: .ASCIZ "How many matchsticks (10-100)?\n"
223|inputMsg3: .ASCIZ "Play again (y/n)?\n\n"
224|// Error Messages
225|errorMsg1: .ASCIZ "Invalid input! Please enter a number between 10 and 100.\n"
226|errorMsg2: .ASCIZ "Invalid input! Please enter a number between 1 and 7.\n"
227|errorMsg3: .ASCIZ "Invalid input! Please enter yes(y) or no(n) decision.\n"
228|// Output Messages
229|outputMsg1: .ASCIZ "\nPlayer 1 is: "
230|outputMsg2: .ASCIZ "Matchsticks: "
231|outputMsg3: .ASCIZ "\nPlayer "
232|outputMsg4: .ASCIZ ", there are "
233|outputMsg5: .ASCIZ "no more "
234|outputMsg6: .ASCIZ "matchsticks remaining."
235|outputMsg7: .ASCIZ ", how many do you want to remove (1-7)?\n"
236|outputMsg8: .ASCIZ "\nComputer’s turn!\n"
237|outputMsg9: .ASCIZ "Computer chose to remove "
238|outputMsg10: .ASCIZ "\nYour turn!"
239|outputMsg11: .ASCIZ "You chose to remove "
240|outputMsg12: .ASCIZ "matchsticks.\n"
241|outputMsg13: .ASCIZ "\n\nGame over!"
242|outputMsg14: .ASCIZ ", YOU WIN!\n"
243|outputMsg15: .ASCIZ ", YOU LOSE!\n"
244|outputMsg16: .ASCIZ "\nIt’s a draw!\n"
