// Messager registers
; R3: Message pointer
// Variable registers
; R11: player's name
; R12: remain matchstick number
      MOV R3, #inputMsg1 ; Prompt for player name
      STR R3, .WriteString
      MOV R11, #playerName ; Reserve space for name input
      STR R11, .ReadString ; Read player name
// Get matchstick number
getMatchstick:
      MOV R3, #inputMsg2 ; Prompt for matchstick number
      STR R3, .WriteString
      LDR R12, .InputNum ; Read matchstick number
      CMP R12, #10      ; Check if < 10
      BLT invalidMatchstick
      CMP R12, #100     ; Check if > 100
      BGT invalidMatchstick
      B displayInfo
// Invalid matchstick number
invalidMatchstick:
      MOV R3, #errorMsg1 ; Show error message
      STR R3, .WriteString
      B getMatchstick
// Display game info
displayInfo:
      MOV R3, #outputMsg1
      STR R3, .WriteString ; Display message
      MOV R3, R11       ; Display player name
      STR R3, .WriteString
      MOV R3, #newLine
      STR R3, .WriteString
      MOV R3, #outputMsg2
      STR R3, .WriteString ; Display matchstick count
      MOV R3, R12
      STR R3, .WriteUnsignedNum
      MOV R3, #newLine
      STR R3, .WriteString
      HALT
// Spaces
newLine: .ASCIZ "\n"    ; New line character
playerName: .BLOCK 128  ; Reserved space for player name
// Input Messages
inputMsg1: .ASCIZ "Please enter your name:\n"
inputMsg2: .ASCIZ "How many matchsticks (10-100)?\n"
// Error Messages
errorMsg1: .ASCIZ "Invalid input! Please enter a number between 10 and 100.\n"
// Output Messages
outputMsg1: .ASCIZ "\nPlayer 1 is: "
outputMsg2: .ASCIZ "Matchsticks: "
