INCLUDE irvine32.INC

;------------------- PROTO-TYPINGS------------------;
BOARDLevel1And3 PROTO , Levelx :byte
InitializeArray1And3 PROTO , Levelx:byte
PrintString PROTO, strptr : ptr dword
atodw PROTO, inputStr:DWORD
;---------------------------------------------------;

;---------------------------DATA Segment--------------------------;
.data
		X byte 37
		Y byte 3
		A byte 25
		B byte 10
		Temp dword ?

		Array byte 10 DUP( 10 DUP(?))
		Array2 byte  9 DUP(9 DUP (?))

		Row  dword ?
		Row2 dword  ?
		Coloumn   dword ?
		Coloumn2  dword ?
		RowSize   dword 10
		RowSize2  dword  9


		Option1 byte "1. Play Now!", 0
		Option2 byte "2. View HighScore", 0
		Option3 byte "3. Exit", 0
		Option4 byte "Level 1 :)",0
		Option5 byte "Level 2 :}",0
		Option6 byte "Level 3 :]",0 

		PromptForOption byte "Enter your Choice: ",0
		PromptForLevel byte "Select Your Level!",0
		PromptForLevelInput byte "Select the level you would like to play? ",0
		PromptToPlayAgain byte "Would you like to play again?",0dh,0ah,0dh,0ah,0dh,0ah
						  byte	"Press [1] for Yes or any other key to Continue: ",0

		PromptForLeaderboard byte "Player Name:      Score:     Level:",0

		WelcomeNoticeLine  byte  "+=========================================+",0
		WelcomeNoticeText1 byte  "|                 Welcome                 |",0
		WelcomeNoticeText2 byte  "|          Number Crunching Game          |",0
		WelcomeNoticeText3 byte  "|    @ Hamza Ismail          22K - 4308   |",0
		WelcomeNoticeText4 byte  "|    @ Sheheryar Salman      22K - 4248   |",0

		PlayerInfoLines byte "+=====================================+",0
		PlayerInfoText byte  "|          Player Information         |",0

		Lines byte				"+---------------------------------------+",0
		Lines2 byte				"+-----------------------------------+",0
		Spaces byte "| ",0
		Spaces2 byte " ",0
		
		Level byte 1
		NAMESTRING byte "Input Name of Player    :  ",0
		username   byte 25 DUP(?)
		Score      dword 0
		Moves    dword 0
		CountDuplicates dword 0


		NameTag    byte "Player Name  : ",0
		Level1Tag  byte "Level        : ",0
		ScoreTag   byte "Scores       : ",0
		MovesTag   byte "Moves        : ",0

		WrongInputMsg byte "-->  Wrong Input!  Try Again!",0
		Input1     byte "Input First Number Index          :   ",0
		Input2     byte "Input Second Number Index         :   ",0
		
		DuplicationCountCheck dword ?
		Num1 dword ?
		Num2 dword ?

		NoComboReSwap byte 	"--> Swapping Back Move NOT Possible",0
		NotPossible byte 	"--> Move NOT Possible",0
		Crushing byte 	"--> Crushing Combinations",0
		Explosion byte "-->	Exploding Bomb",0

		; File Handling Variables
		filename BYTE "PlayersRecord.txt", 0
		fileHandle HANDLE ?
		filename2 BYTE "HighestScores.txt", 0
		fileHandle2 HANDLE ?
		filename3 BYTE "Names.txt",0
		fileHandle3 HANDLE ?
		filename4 byte "Level.txt",0
		filehandle4 HANDLE ?
		BytesWritten DWORD ?
		noOfbytes DWORD ?
		NextLine BYTE 0DH, 0AH
		tempRead BYTE 100 dup(?)
		BytesRead DWORD ?

		Level1FileHandling		  byte "Level-1     :  ",0
		Level2FileHandling		  byte "Level-2     :  ",0
		Level3FileHandling		  byte "Level-3     :  ",0
		HighestScoreFileHandling  byte "Best Score  :  ",0
		Highest dword 0
		LevelToStore byte "?",0
		Level1Score dword   0
		Level2Score dword   0
		Level3Score dword   0
		ScoreToString byte 5 dup (" "), 0

		
	
;---------------------------------------------------------------------;



;---------------------Code Segment------------------------------------;
.code
main proc

call WelcomeNote
call clrscr
call InputPlayerInfo

INVOKE CreateFile,ADDR fileName,GENERIC_WRITE+GENERIC_READ,DO_NOT_SHARE,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
mov fileHandle,eax
INVOKE SetFilePointer,fileHandle,0,0,FILE_END
INVOKE WriteFile, fileHandle,ADDR NameTag, SIZEOF NameTag,ADDR bytesWritten,NULL
INVOKE WriteFile, fileHandle,ADDR username, SIZEOF username,ADDR bytesWritten,NULL
INVOKE WriteFile, fileHandle,ADDR NextLine, SIZEOF NextLine,ADDR bytesWritten,NULL

INVOKE CreateFile, ADDR filename2, GENERIC_WRITE+GENERIC_READ,DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,0
mov filehandle2, eax

INVOKE CreateFile, ADDR filename3, GENERIC_WRITE+GENERIC_READ,DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,0
mov filehandle3, eax

INVOKE CreateFile, ADDR filename4, GENERIC_WRITE+GENERIC_READ,DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,0
mov filehandle4, eax

call menu


;INVOKE WriteFile, fileHandle,ADDR HighestScoreFileHandling, SIZEOF HighestScoreFileHandling,ADDR bytesWritten,NULL
;INVOKE WriteFile, fileHandle,ADDR ScoreToString, SIZEOF ScoreToString,ADDR bytesWritten,NULL
;INVOKE WriteFile, fileHandle,ADDR NextLine, SIZEOF NextLine,ADDR bytesWritten,NULL
;INVOKE WriteFile, fileHandle,ADDR NextLine, SIZEOF NextLine,ADDR bytesWritten,NULL



INVOKE CloseHandle, fileHandle
INVOKE CloseHandle, fileHandle2
INVOKE CloseHandle, fileHandle3
INVOKE CloseHandle, fileHandle4


call waitmsg

exit
main endp

;----------------------------------MAin Ends------------------------------;

showdisplayboard proc

	call clrscr
	mov X, 35
	mov Y, 5
	call position
	mov edx, offset promptforleaderboard
	call writestring

	inc y
	call position
	INVOKE ReadFile, filehandle3, addr tempRead, 25, addr bytesRead, 0
	mov edx, offset tempread
	call writestring

	add x, 15
	dec y
	call position
	INVOKE ReadFile, filehandle2, addr tempread, 25, addr bytesRead, 0
	mov edx, offset tempread
	mov ecx, bytesRead
	call writestring
	
	add x, 15
	dec y
	call position
	INVOKE ReadFile, filehandle4, addr tempread, 2, addr bytesRead, 0
	mov edx, offset tempread
	call writestring

	mov x, 40
	mov y, 15
	call position
	call waitmsg

ret
showdisplayboard endp

StoreHighScore proc
	
	call GetHighest

	INVOKE ReadFile, filehandle2, addr tempRead, 100, addr bytesRead, 0 
	INVOKE atodw, addr tempRead
	
	mov eax, score
	cmp eax, highest
	
	jle endd

	call ConvertScoreToString
	
	invoke SetFilePointer, filehandle2, 0, 0, FILE_BEGIN
	invoke SetFilePointer, filehandle3, 0, 0, FILE_BEGIN
	invoke SetFilePointer, filehandle4, 0, 0, FILE_BEGIN
	INVOKE WriteFile, fileHandle2,ADDR ScoreToString, SIZEOF scoretostring ,ADDR bytesWritten,NULL
	INVOKE WriteFile, fileHandle3,ADDR Username, SIZEOF Username,ADDR bytesWritten,NULL
	INVOKE WriteFile, fileHandle4,ADDR Leveltostore, SIZEOF Leveltostore, ADDR bytesWritten, NULL
 
endd:
ret
StoreHighScore endp

atodw proc uses edx esi edi inputStr:DWORD
    xor  eax, eax ; Clear the result

    ; Iterate through each character in the string
    mov  esi, inputStr
convert_loop:
    movzx edi, byte ptr [esi] ; Load the next character into edi, zero-extended
    cmp edi, 0 ; Check if it's the null terminator
    je  convert_done

	cmp edi, ' '
	je skipp
    sub edi, '0' ; Convert ASCII character to numeric value
    imul eax, eax, 10 ; Multiply the current result by 10
    add eax, edi ; Add the current digit to the result

	skipp:
    inc esi ; Move to the next character
    jmp convert_loop

convert_done:
	mov Highest, eax
    ret
atodw endp

WelcomeNote proc

mov eax, lightgray + (black * 16)
call setTextcolor
call clrscr
mov A, 40
call Position2
invoke PrintString, addr WelcomeNoticeLine

call Position2
invoke PrintString, addr WelcomeNoticeText1

call Position2
invoke PrintString, addr WelcomeNoticeText2

call Position2
invoke PrintString, addr WelcomeNoticeText3

call Position2
invoke PrintString, addr WelcomeNoticeText4

call Position2
invoke PrintString, addr WelcomeNoticeLine

add B, 2
call Position2
call waitmsg

ret
WelcomeNote endp

Position proc
	

	mov dl, X
	mov dh, Y
	call gotoxy
	add Y, 1
ret
Position endp

Position2 PROC
	
	
	mov dl,A
	mov dh,B
	call gotoxy
	add B,1

ret
Position2 endp

IndexPosition PROC
	
	mov dl, A
	mov dh, B
	call gotoxy

ret
IndexPosition endp

PrintString proc, strptr : ptr dword
	
	push edx
	mov edx, strptr
	call writestring
	call crlf
	pop edx
	
ret
PrintString endp

;----------------------INPUT PLayer Info FUNCTION---------------------------;
InputPlayerInfo PROC uses eax ecx ebx edx esi edi

mov X, 35
mov y, 7
call position
mov edx,offset NameString 
call writestring

mov ecx,25
mov edx, offset username
call readstring
call crlf


ret
InputPlayerInfo ENDP
;-------------------------------------------------------------------------;


;------------------------------MENU DISPLAY--------------------------------;
menu proc
	
	againask:
	mov x, 50
	mov y, 5
	call clrscr

	call position

	mov edx, offset Option1
	call writestring
	
	call position

	mov edx, offset Option2
	call writestring
	call position

	mov edx, offset Option3
	call writestring
	call crlf

	mov y, 10
	

	
	call position
	mov edx, offset PromptForOption
	call writestring
	call readint

	cmp eax, 1
	jl wronginput
	cmp eax, 3
	jg wronginput
	jmp done
	wronginput:
	mov edx, offset WrongInputMsg
	call writestring
	mov eax, 1300
	call delay
	jmp againask

	done:
	cmp eax, 1
	je firstoption
	cmp eax, 2
	je secondoption
	cmp eax, 3
	je endd
	
	firstoption:
		
		call playmenu
		call StoreHighScore
		jmp againask

	jmp endd
	secondoption:
	
		call showDisplayBoard
		jmp againask

	jmp endd

endd:
ret
menu endp

playmenu proc
	
	againask:
	call clrscr
	mov x, 46
	mov y, 5

	call position
	mov edx, offset PromptForLevel
	call writestring

	mov x, 50
	inc y
	call position
	mov edx, offset Option4
	call writestring

	call position
	mov edx, offset Option5
	call writestring
	
	call position
	mov edx, offset Option6
	call writestring

	mov x, 42
	mov y, 12
	call position
	mov edx, offset Promptforlevelinput
	call writestring
	call readint

	cmp eax, 1
	jl wronginput
	cmp eax, 3
	jg wronginput
	jmp done
	wronginput:
	mov edx, offset WrongInputMsg
	call writestring
	mov eax, 1300
	call delay
	jmp againask

	done:

	cmp eax, 1
	je firstoption

	cmp eax, 2
	je secondoption

	mov level, 3
	call playlevel3
	jmp replay

	firstoption:
		mov level, 1
		call playlevel1
		jmp replay

	secondoption:
		mov level, 2
		call playlevel2

	replay:
		call clrscr
		mov X, 35
		mov Y, 7
		call position
		mov edx, offset PromptToPlayAgain
		call writestring

		call readint

		cmp eax, 1
		je againask

endd:	
ret
playmenu endp

;-------------------------------------------------------------------------;

;-----------------------Show Indexes-------------------------------------;
PrintIndexes PROC uses eax ecx ebx edx esi edi


mov B,9
mov A,31
mov eax,0
mov ecx,10
Loop1:
call IndexPosition
call Writedec

inc eax
add A,4
LOOP Loop1

call crlf

mov B,11
mov A,24
mov eax,0
mov ecx,10
Loop2:
call IndexPosition
call Writedec

add eax,10
add B,2
LOOP Loop2


ret
PrintIndexes ENDP
;-------------------------------------------------------------------------;




;-----------------------Show Indexes-------------------------------------;
Level2PrintIndexes PROC uses eax ecx ebx edx esi edi


mov B,9
mov A,32
mov eax,0
mov ecx,9
Loop1:
call IndexPosition
call Writedec

inc eax
add A,4
LOOP Loop1

call crlf


mov B,12
mov A,25
mov eax,0
mov ecx,9
Loop2:
call IndexPosition
call Writedec

add eax,9
add B,2
LOOP Loop2


ret
Level2PrintIndexes ENDP
;-------------------------------------------------------------------------;


;----------------------Generate Board Level1 FUNCTION-------------------;
BOARDLevel1And3 PROC  uses eax ecx ebx edx esi edi , Levelx :byte

call PrintIndexes 

mov B,10
mov A,29
call TablePosition
invoke PrintString, addr Lines

mov esi, offset Array

mov ebx, 0
mov ecx,10

Loop1:
push ecx
push esi

call TablePosition
mov ecx,10
Loop2:

mov edx,offset Spaces
call writeString

mov eax,0

mov al, [esi]
movzx edx,al
call SetColour
cmp al,'B'
jz PrintB
cmp al,'X'
jz PrintB

call writedec
jmp done

PrintB:
call WriteChar

done:
call SetInitialColour
mov edx,offset Spaces2
call writeString

add esi, Type Array

LOOP Loop2


pop esi
pop ecx
mov al,'|'
call Writechar
call crlf

call TablePosition
invoke PrintString, addr Lines

add esi, 10

LOOP Loop1


ret
BOARDLevel1And3 ENDP

;--------------------------------------------------------------------------;





;--------------------Generate Board Level2 FUNCTION------------------------;
BOARDLevel2 PROC  uses eax ecx ebx edx esi edi

call Level2PrintIndexes

mov B,11
mov A,30
call TablePosition
invoke PrintString, addr Lines2

mov esi, offset Array2

mov ecx,9
Loop1:

push ecx
push  esi
mov ecx,9

call TablePosition
Loop2:

mov edx,offset Spaces
call writeString

mov eax,0
mov al, [esi]
movzx edx,al
push eax
call SetColour
pop eax
cmp al,' '
jz PrintSpace
cmp al,'B'
jz PrintSpace

call writedec
jmp Done

PrintSpace:
call WriteChar


Done:
CALL SetInitialColour
mov edx,offset Spaces2
call writeString
add esi,Type Array2


LOOP Loop2

pop esi
pop ecx
mov al,'|'
call Writechar
call crlf

call TablePosition
invoke PrintString, addr Lines2

add esi,9

LOOP Loop1

ret
BOARDLevel2 ENDP
;-------------------------------------------------------------------------------;





;----------------------------------SET Colours ---------------------------------;
SetColour proc Uses eax ebx ecx edx esi

cmp edx,'B'
jz Bomb
cmp edx,' '
jz Space
cmp edx,'X'
jz Block
cmp edx,1
jz Colour1
cmp edx,2
jz Colour2
cmp edx,3
jz Colour3
cmp edx,4
jz Colour4
cmp edx,5
jz Colour5
Space:
mov  eax,white+(black*16)
call SetTextColor
jmp Done
Bomb:
mov  eax,yellow+(black*16)
call SetTextColor
jmp Done
Block:
mov  eax,gray+(black*16)
call SetTextColor
jmp Done
Colour1:
mov  eax,lightmagenta+(black*16)
call SetTextColor
jmp Done
Colour2:
mov  eax,lightcyan+(black*16)
call SetTextColor
jmp Done
Colour3:
mov  eax,green+(black*16)
call SetTextColor
jmp Done
Colour4:
mov  eax,brown+(black*16)
call SetTextColor
jmp Done
Colour5:
mov  eax,blue+(black*16)
call SetTextColor


Done:
ret 
SetColour Endp
;-----------------------------------------------------------------------------;





;----------------------------SET Initial Colours--------------------------------;
SetInitialColour proc Uses eax ebx ecx edx esi

mov  eax,lightgray +(black*16)
call SetTextColor

ret 
SetInitialColour Endp
;--------------------------------------------------------------------------------;





;--------------------------Set Information Text Colour--------------------------;
SetInfoColour PROC  uses eax ecx ebx edx esi edi

mov  eax,lightcyan+(black*16)
call SetTextColor

ret
SetInfoColour ENDP
;-----------------------------------------------------------------------------;




;--------------------------Set Information Text Colour------------------------;
SetCrushedNumberColour PROC  uses eax ecx ebx edx esi edi

mov  eax,white+(red*16)
call SetTextColor

ret
SetCrushedNumberColour ENDP
;----------------------------------------------------------------------------;



;-----------------------Initialize Array Level1 FUNCTION-----------------------;
InitializeArray1And3 PROC  uses eax ecx ebx edx esi edi, Levelx:byte

call randomize
mov ecx,10
mov esi,offset Array

Loop1:
push ecx 
push esi

mov ecx,10
Loop2:	

cmp Levelx,3
jz Levelis3
mov eax,9
call randomRange
cmp eax,1
jz StoreB

mov eax, 5
call randomRange
inc eax
jmp Done

StoreB:
mov al,'B'
jmp Done


Levelis3:
mov eax,9
call randomRange
cmp eax,1
jz StoreB3
cmp eax,2
jz StoreX

mov eax,0
mov eax, 5
call randomRange
inc eax
jmp Done

StoreB3:
mov al,'B'
jmp Done

StoreX:
mov al,'X'

Done:
mov [esi], al

add esi, type Array

LOOP Loop2
pop esi
POP ecx
add esi, 10

LOOP Loop1

	ret
InitializeArray1And3 ENDP
;---------------------------- ---------------- -----------------------------;





;-----------------------Initialize Array Level2 FUNCTION------------------------;
InitializeArray2 PROC  uses eax ecx ebx edx esi edi


mov Row2, 0
mov Coloumn2, 0

mov esi,offset Array2
mov ecx,9
call Randomize
Loop1:

push ecx
push esi
mov Coloumn2, 0
mov ecx,9

Loop2:

call CheckMiddle

cmp eax,1
jz RandomNumber

cmp eax,2
jz Space

RandomNumber:
mov eax,9
call RandomRange
cmp eax,1
jz StoreB
cmp eax,2
jz StoreB

mov eax,4
call RandomRange
inc eax
jmp Done

StoreB:
mov al,'B'
jmp Done

Space:
mov al,' '

Done:

mov  [esi],al

add esi,1
inc Coloumn2

LOOP Loop2

pop esi
pop ecx
add esi, 9
inc Row2

LOOP Loop1

ret 
InitializeArray2 ENDP

;------------------------- ---------------- ------------------------------;




;------------------------- Checking Middles To Skip Spaces ----------------------;
CheckMiddle proc

mov edx,Row2
cmp edx,4
jz Middle
jnz Second

Middle:
mov edx,Coloumn2
cmp edx,3
jz Space
cmp edx,4
jz Space
cmp edx,5
jz Space

Second:
mov edx,Coloumn2
cmp edx,3
jz RandomNumber
cmp edx,4
jz RandomNumber
cmp edx,5
jz RandomNumber
mov edx,Row2
cmp edx,3
jz RandomNumber
cmp edx,4
jz RandomNumber
cmp edx,5
jz RandomNumber
jnz Space

RandomNumber:
mov eax,1
jmp done

Space:
mov eax,2

done:
ret
CheckMiddle endp
;------------------------- ----------------------- ----------------------;




;----------------- MACRO Display Function---------------;
TablePosition proc  uses eax ecx ebx edx esi edi

call Position2

ret
TablePosition endp
;---------------------------------------------------;




;----------------- Set Position Function---------------;
SetPosition PROC  uses eax ecx ebx edx esi edi

mov X, 37
mov Y, 0 
mov A, 30
mov B, 0

ret
SetPosition ENDP
;-----------------------------------------------------------;




;--------------------MACRO To Display Player Info---------------;
DisplayPlayerInfo PROC
pusha
call SetInfoColour

call Position2

invoke PrintString, addr PlayerInfoLines

call Position2

invoke PrintString, addr PlayerInfoText

call Position2

invoke PrintString, addr PlayerInfoLines


mov X, 37
mov Y, 3

call Position

mov edx, offset NameTag
call writestring
mov edx, offset Username
call writestring
call crlf

call Position
mov edx,offset Level1Tag
call WriteString
movzx eax,level
call writedec
call crlf

call Position
mov edx,offset MovesTag
call WriteString
mov eax,Moves
call writedec
call crlf

call Position
mov edx,offset ScoreTag
call WriteString
mov eax,Score
call writedec
call crlf

MOV B,7
call Position2
invoke PrintString, addr PlayerInfoLines

call  SetInitialColour

popa
ret
DisplayPlayerInfo ENDP
;--------------------------------------------------------------------;



;-----------------------	Level 1 & 3 Logics		-------------------------------;
;-----------------------	Level 1 & 3 Logics		-------------------------------;
;-----------------------	Level 1 & 3 Logics		-------------------------------;

;----------------------- Find Row Duplicates---------------------;
RowRemoveDuplicates PROC

mov esi, offset Array
mov ecx,10
Loop1:
push ecx
push esi
mov ecx,10

Loop2:

mov al,[esi]
mov dl,[esi+1]
cmp ecx,1
je LAST
cmp al,dl
jz IsEqual
jnz CheckCombos

LAST:
cmp al,dl
jne CheckCombos
inc CountDuplicates

CheckCombos:
cmp CountDuplicates,2
jnae NotCombo

call RowCrush

jmp Done

IsEqual:
inc CountDuplicates
jmp Done

NotCombo:
mov CountDuplicates,0

Done:
add esi, type Array

Loop Loop2
mov CountDuplicates,0
pop esi
pop ecx
add esi, 10

LOOP Loop1

mov CountDuplicates,0

ret
RowRemoveDuplicates ENDP
;--------------------------------------------------------------------------;




;----------------------- Crush Combos Row Duplicates---------------------;
RowCrush PROC  uses eax ecx ebx edx esi edi

inc CountDuplicates
mov ecx,CountDuplicates
add Score,ecx

call Randomize
Loop3:

mov eax,5
call randomRange
inc eax

mov [esi],al
sub esi,1

LOOP Loop3

mov CountDuplicates,0

ret
RowCrush ENDP
;--------------------------------------------------------------------------;





;;----------------------- Finding Coloumn Duplicates------------------------;
ColoumnRemoveDuplicates PROC

mov esi, offset Array
mov ecx,10
Loop1:
push ecx
push esi
mov ecx,10

Loop2:

mov al,[esi]
mov dl,[esi+10]
cmp ecx,1
je LAST
cmp al,dl
jz IsEqual
jnz CheckCombos

LAST:
cmp al,dl
jne CheckCombos
inc CountDuplicates

CheckCombos:
cmp CountDuplicates,2
jnae NotCombo


call ColoumnCrush


jmp Done

IsEqual:
inc CountDuplicates
jmp Done

NotCombo:
mov CountDuplicates,0

Done:
add esi, 10

Loop Loop2
mov CountDuplicates,0
pop esi
pop ecx
add esi, 1

LOOP Loop1

mov CountDuplicates,0

ret
ColoumnRemoveDuplicates ENDP
;;------------------------------------------------------------------------------;




;----------------------- Crushing Coloumn Duplicates----------------------------;
ColoumnCrush PROC  uses eax ecx ebx edx esi edi

inc CountDuplicates
mov ecx,CountDuplicates
add Score,ecx
call Randomize
Loop3:

mov eax,5
call randomRange
inc eax

mov [esi],al
sub esi,10

LOOP Loop3

mov CountDuplicates,0

ret
ColoumnCrush ENDP
;;------------------------------------------------------------------------------;






;-------------Function Calls Row And Coloumn Duplication Remove ---------------;
RemoveCombos PROC 

call RowRemoveDuplicates
call ColoumnRemoveDuplicates

ret
RemoveCombos ENDP
;;------------------------------------------------------------------------------;





;----------------------- Checking Coloumn Duplicates----------------------------;
ColoumnCheckDuplicates PROC 

mov esi, offset Array
mov ecx,10
Loop1:
push ecx
push esi
mov ecx,8
Loop2:

mov al,[esi]
mov dl,[esi+10]
cmp al,dl
jnz NotCombo
mov dl,[esi+20]
cmp al,dl
jnz NotCombo

mov edx,1
JMP IsCombo

NotCombo:
add esi,10

Loop Loop2
pop esi
pop ecx
add esi,1

LOOP Loop1

mov edx,2
jmp Done

IsCombo:
pop esi
pop ecx

Done:

ret
ColoumnCheckDuplicates ENDP
;;------------------------------------------------------------------------------;





;----------------------- Checking Row Duplicates----------------------------;
RowCheckDuplicates PROC

mov esi, offset Array
mov ecx,10

Loop1:
push ecx
push esi
mov ecx,8
Loop2:

mov al,[esi]
mov dl,[esi+1]
cmp al,dl
jnz NotCombo
mov dl,[esi+2]
cmp al,dl
jnz NotCombo

mov edx,1
JMP IsCombo

NotCombo:
add esi, 1

Loop Loop2
pop esi
pop ecx
add esi, 10

LOOP Loop1

mov edx,2
jmp Done

IsCombo:
pop esi
pop ecx

Done:

ret
RowCheckDuplicates ENDP
;--------------------------------------------------------------------------;





;---------------------  Whether Any Combo Availible or Not  -----------------;
CheckDuplicates PROC									    

mov DuplicationCountCheck,0
CheckAgain:
CALL RowCheckDuplicates
cmp edx,1
jz Duplicate
CALL ColoumnCheckDuplicates
cmp edx,1
jnz NoDuplicate

Duplicate:
inc DuplicationCountCheck
call RemoveCombos
jmp CheckAgain

NoDuplicate:
cmp DuplicationCountCheck,0
je Done
inc Moves

Done:

ret
CheckDuplicates ENDP
;--------------------------------------------------------------------------;



;--------------------- Input For Swapping---------------------------;
MoveInput PROC 

AgainInput:
call clrscr
call SetPosition
call DisplayPlayerInfo
call crlf
INVOKE BOARDLevel1And3,Level


mov edx, offset Input1
call WriteString
call readint
mov Num1,eax

mov edx, offset Input2
call WriteString
call readint
mov Num2,eax

call HighlightSwaps

cmp Num1,0
jl WrongInput
cmp Num1,100
jge WrongInput
cmp Num2,0
jl WrongInput
cmp Num2,100
jge WrongInput

mov eax, Num1
mov ebx, Num2
cmp Array[eax],'X'
jz MoveNotPossible
cmp Array[ebx],'X'
jz MoveNotPossible


cmp Array[eax],'B'
jne NextCondition
cmp Array[ebx],'B'
jne NextCondition

jmp MoveNotPossible


NextCondition:
cmp eax, ebx
je MoveNotPossible


dec eax
cmp eax,ebx
je MovePossible

add eax,2
cmp eax,ebx
je MovePossible

mov eax, Num1
mov ebx, Num2

sub eax,10
cmp eax,ebx
je MovePossible

add eax,20
cmp eax,ebx
je MovePossible


WrongInput:
call JumpLines
mov edx, offset WrongInputMsg
call WriteString
call ScreenSleep
jmp AgainInput

MoveNotPossible:
call JumpLines
mov edx, offset NotPossible
call writeString
call ScreenSleep
jmp done

MovePossible:
call SWAP
jmp done

done:

ret
MoveInput ENDP
;--------------------------------------------------------------------------;




;-------------------- Swap Two Number If Movement Possible   -----------------;
SWAP PROC

mov ecx,Num1
mov edx,Num2

mov al, Array[ecx]
mov bl, Array[edx]

mov  Array[ecx],bl
mov  Array[edx],al


cmp Array[ecx],'B'
je ItsBomb
cmp Array[edx],'B'
je ItsBomb


call ColoumnCheckDuplicates
cmp edx,1
jz ComboPossible
call RowCheckDuplicates
cmp edx,1
jnz NoCombo

ComboPossible:
call JumpLines
mov edx,offset Crushing
call writeString
call ScreenSleep

call CheckDuplicates
jmp Done


NoCombo:
call JumpLines
mov edx, offset NoComboReSwap
call writeString
call ScreenSleep
call ReSwap
jmp Done

ItsBomb:
call InitiateBomb

Done:

ret
SWAP ENDP
;--------------------------------------------------------------------------;


JumpLines PROC

call crlf
call crlf

RET
JumpLines ENDP


;-------------------------- If Not Crush Re-Swap   --------------------------;
ReSwap PROC 


mov ecx,Num1
mov edx,Num2

mov al, Array[ecx]
mov bl, Array[edx]

mov  Array[ecx],bl
mov  Array[edx],al


ret
ReSwap ENDP
;--------------------------------------------------------------------------;




;--------------- Hinghlight Bombed Colours ----------------;
HighlightSwaps PROC uses eax ebx ecx edx esi edi

mov edi,Num1
mov ebx,Num2
add edi,offset Array
add ebx,offset Array

call PrintIndexes 

mov B,10
mov A,29
call TablePosition
invoke PrintString, addr Lines

mov esi, offset Array

mov ecx,10

Loop1:
push ecx
push esi

call TablePosition
mov ecx,10
Loop2:

mov edx,offset Spaces
call writeString

mov al, [esi]
movzx edx,al
cmp esi,ebx
je SetExplosionColour
cmp esi,edi
je SetExplosionColour
jmp NotExplosionColour

SetExplosionColour:
call SetCrushedNumberColour
jmp Compare

NotExplosionColour:
call SetColour

Compare:
cmp al,'B'
jz PrintB
cmp al,'X'
jz PrintB

call writedec
jmp done

PrintB:
call WriteChar

done:
call SetInitialColour
mov edx,offset Spaces2
call writeString

add esi, Type Array

LOOP Loop2


pop esi
pop ecx
mov al,'|'
call Writechar
call crlf

call TablePosition
mov edx,offset Lines
call writeString
call crlf

add esi, 10

LOOP Loop1


ret
HighlightSwaps ENDP
;-----------------------------------------------------------;


;--------------- Hinghlight Bombed Colours ----------------;
HighlightBomb PROC uses eax ebx ecx edx esi edi

call PrintIndexes 

mov B,10
mov A,29
call TablePosition
invoke PrintString, addr Lines

mov esi, offset Array

mov ecx,10

Loop1:
push ecx
push esi

call TablePosition
mov ecx,10
Loop2:

mov edx,offset Spaces
call writeString

mov al, [esi]
movzx edx,al
cmp bl,al
je SetExplosionColour
cmp esi,edi
je SetExplosionColour
jmp NotExplosionColour

SetExplosionColour:
call SetCrushedNumberColour
jmp Compare

NotExplosionColour:
call SetColour

Compare:
cmp al,'B'
jz PrintB
cmp al,'X'
jz PrintB

call writedec
jmp done

PrintB:
call WriteChar

done:
call SetInitialColour
mov edx,offset Spaces2
call writeString

add esi, Type Array

LOOP Loop2


pop esi
pop ecx
mov al,'|'
call Writechar
call crlf

call TablePosition
mov edx,offset Lines
call writeString

call crlf
add esi, 10

LOOP Loop1


ret
HighlightBomb ENDP
;-----------------------------------------------------------;




;--------------- If Any Swapped Number is B initiate Bomb----------------;
InitiateBomb PROC

call JumpLines
mov edx,offset Explosion
call writeString
call ScreenSleep

mov eax,Moves
mov Temp,eax

mov eax, Num1
mov ebx, Num2
add eax,offset Array
mov esi,eax
add ebx,offset Array
mov edi,ebx

mov eax,0
mov  al,[esi]
cmp al,'B'
jz BombAddress1
mov eax,0
mov  al,[edi]
cmp al,'B'
jz BombAddress2

BombAddress1:
mov ebx,0
mov ebx,[edi]
mov edi,esi
jmp Start

BombAddress2:
mov ebx,[esi]

Start:
mov esi, offset Array

call HighlightBomb
call ScreenSleep

mov ecx,10
Loop1:
push ecx
push esi
mov ecx,10
Loop2:
mov dl,[esi]
cmp bl,dl
jnz NotBombNumber

mov eax,1
add Score,eax
mov eax,5
call randomRange
inc eax
mov [esi],al


NotBombNumber:
add esi, 1

Loop Loop2


pop esi
pop ecx
add esi, 10

LOOP Loop1


mov eax,5
call randomRange
inc eax
mov [edi],al

call CheckDuplicates
mov eax,Temp
inc eax
mov Moves,eax

ret
InitiateBomb ENDP
;------------------------------------------------------;
;------------------------------------------------------;
;------------------------------------------------------;





;-----------------------	Level 2 Logics		-------------------------------;
;-----------------------	Level 2 Logics		-------------------------------;
;-----------------------	Level 2 Logics		-------------------------------;



;----------------------- Find Row Duplicates---------------------;
Level2RowRemoveDuplicates PROC
mov CountDuplicates,0
mov esi, offset Array2
mov ecx,9
Loop1:
push ecx
push esi
mov ecx,9

Loop2:

mov al,[esi]
mov dl,[esi+1]
cmp al, ' '
je ChcekCombos
cmp ecx,1
je LAST
cmp al,dl
jz IsEqual
jnz ChcekCombos

LAST:
cmp al,dl
jne ChcekCombos
inc CountDuplicates

ChcekCombos:
cmp CountDuplicates,2
jnae NotCombo

call Level2RowCrush

jmp Done

IsEqual:
inc CountDuplicates
jmp Done

NotCombo:
mov CountDuplicates,0

Done:
add esi, type Array2

Loop Loop2
mov CountDuplicates,0
pop esi
pop ecx
add esi, 9

LOOP Loop1

mov CountDuplicates,0

ret
Level2RowRemoveDuplicates ENDP
;--------------------------------------------------------------------------;




;----------------------- Crush Combos Row Duplicates---------------------;
Level2RowCrush PROC  uses eax ecx ebx edx esi edi

inc CountDuplicates
mov ecx,CountDuplicates
add Score,ecx

call Randomize
Loop3:

mov eax,4
call randomRange
inc eax

mov [esi],al
sub esi,1

LOOP Loop3

mov CountDuplicates,0

ret
Level2RowCrush ENDP
;--------------------------------------------------------------------------;





;;----------------------- Finding Coloumn Duplicates------------------------;
Level2ColoumnRemoveDuplicates PROC

mov esi, offset Array2
mov ecx,9
Loop1:
push ecx
push esi
mov ecx,9

Loop2:

mov al,[esi]
mov dl,[esi+9]
cmp al,' '
je ChcekCombos
cmp ecx,1
je LAST
cmp al,dl
jz IsEqual
jnz ChcekCombos

LAST:
cmp al,dl
jne ChcekCombos
inc CountDuplicates

ChcekCombos:
cmp CountDuplicates,2
jnae NotCombo


call Level2ColoumnCrush

jmp Done

IsEqual:
inc CountDuplicates
jmp Done

NotCombo:
mov CountDuplicates,0

Done:
add esi, 9

Loop Loop2
mov CountDuplicates,0
pop esi
pop ecx
add esi, 1

LOOP Loop1

mov CountDuplicates,0

ret
Level2ColoumnRemoveDuplicates ENDP
;;------------------------------------------------------------------------------;



;----------------------- Crushing Coloumn Duplicates----------------------------;
Level2ColoumnCrush PROC  uses eax ecx ebx edx esi edi

inc CountDuplicates
mov ecx,CountDuplicates
add Score,ecx
call Randomize
Loop3:

mov eax,4
call randomRange
inc eax

mov [esi],al
sub esi,9

LOOP Loop3

mov CountDuplicates,0

ret
Level2ColoumnCrush ENDP
;;------------------------------------------------------------------------------;






;-------------Function Calls Row And Coloumn Dupliation Remove ---------------;
Level2RemoveCombos PROC 

call Level2RowRemoveDuplicates
call Level2ColoumnRemoveDuplicates

ret
Level2RemoveCombos ENDP
;;------------------------------------------------------------------------------;





;----------------------- Checking Coloumn Duplicates----------------------------;
Level2ColoumnCheckDuplicates PROC 

mov esi, offset Array2
mov ecx,9
Loop1:
push ecx
push esi
mov ecx,7
Loop2:

mov al,[esi]
mov dl,[esi+9]
cmp al,' '
je NotCombo
cmp al,dl
jnz NotCombo
mov dl,[esi+18]
cmp al,dl
jnz NotCombo

mov edx,1
JMP IsCombo

NotCombo:
add esi,9

Loop Loop2
pop esi
pop ecx
add esi,1

LOOP Loop1

mov edx,2
jmp Done

IsCombo:
pop esi
pop ecx

Done:

ret
Level2ColoumnCheckDuplicates ENDP
;;------------------------------------------------------------------------------;





;----------------------- Checking Row Duplicates----------------------------;
Level2RowCheckDuplicates PROC

mov esi, offset Array2
mov ecx,9

Loop1:
push ecx
push esi
mov ecx,7
Loop2:

mov al,[esi]
mov dl,[esi+1]
cmp al,' '
je NotCombo
cmp al,dl
jnz NotCombo
mov dl,[esi+2]
cmp al,dl
jnz NotCombo

mov edx,1
JMP IsCombo

NotCombo:
add esi, 1

Loop Loop2
pop esi
pop ecx
add esi, 9

LOOP Loop1

mov edx,2
jmp Done

IsCombo:
pop esi
pop ecx

Done:

ret
Level2RowCheckDuplicates ENDP
;--------------------------------------------------------------------------;





;---------------------  Whether Any Combo Availible or Not  -----------------;
Level2CheckDuplicates PROC									    

mov DuplicationCountCheck,0
Level2CheckAgain:
CALL Level2RowCheckDuplicates
cmp edx,1
jz Level2Duplicate
CALL Level2ColoumnCheckDuplicates
cmp edx,1
jnz Level2NoDuplicate

Level2Duplicate:
inc DuplicationCountCheck

call Level2RemoveCombos
jmp Level2CheckAgain

Level2NoDuplicate:
cmp DuplicationCountCheck,0
je Level2Done
inc Moves

Level2Done:

ret
Level2CheckDuplicates ENDP
;--------------------------------------------------------------------------;



;--------------------- Input For Swapping---------------------------;
Level2MoveInput PROC 

Level2AgainInput:
call clrscr
call SetPosition
call DisplayPlayerInfo
call crlf
INVOKE BOARDLevel2


mov edx, offset Input1
call WriteString
call readint
mov Num1,eax

mov edx, offset Input2
call WriteString
call readint
mov Num2,eax

call Level2HighlightSwaps

cmp Num1,0
jl WrongInput
cmp Num1,90
jge WrongInput
cmp Num2,0
jl WrongInput
cmp Num2,90
jge WrongInput

mov eax, Num1
mov ebx, Num2
cmp Array2[eax],' '
jz MoveNotPossible
cmp Array2[ebx],' '
jz MoveNotPossible


cmp Array2[eax],'B'
jne NextCondition
cmp Array2[ebx],'B'
jne NextCondition

jmp MoveNotPossible


NextCondition:
cmp eax, ebx
je MoveNotPossible


dec eax
cmp eax,ebx
je MovePossible

add eax,2
cmp eax,ebx
je MovePossible

mov eax, Num1
mov ebx, Num2

sub eax,9
cmp eax,ebx
je MovePossible

add eax,18
cmp eax,ebx
je MovePossible


WrongInput:
call JumpLines
invoke PrintString, addr WrongInputMsg
call ScreenSleep
jmp Level2AgainInput

MoveNotPossible:
call JumpLines
invoke PrintString, addr NotPossible
call ScreenSleep
jmp done

MovePossible:
call Level2SWAP
jmp done

done:

ret
Level2MoveInput ENDP
;--------------------------------------------------------------------------;




;-------------------- Swap Two Number If Movement Possible   -----------------;
Level2SWAP PROC

mov ecx,Num1
mov edx,Num2

mov al, Array2[ecx]
mov bl, Array2[edx]

mov  Array2[ecx],bl
mov  Array2[edx],al


cmp Array2[ecx],'B'
je ItsBomb
cmp Array2[edx],'B'
je ItsBomb


call Level2ColoumnCheckDuplicates
cmp edx,1
jz Level2ComboPossible
call Level2RowCheckDuplicates
cmp edx,1
jnz Level2NoCombo

Level2ComboPossible:
call JumpLines
invoke PrintString, addr Crushing
call ScreenSleep

call Level2CheckDuplicates
jmp Done


Level2NoCombo:
call JumpLines
invoke PrintString, addr NoComboReSwap
call ScreenSleep
call Level2ReSwap
jmp Done

ItsBomb:
call Level2InitiateBomb

Done:

ret
Level2SWAP ENDP
;--------------------------------------------------------------------------;




;-------------------------- If Not Crush Re-Swap   --------------------------;
Level2ReSwap PROC 


mov ecx,Num1
mov edx,Num2

mov al, Array2[ecx]
mov bl, Array2[edx]

mov  Array2[ecx],bl
mov  Array2[edx],al


ret
Level2ReSwap ENDP
;--------------------------------------------------------------------------;



;--------------- Hinghlight Bombed Colours ----------------;
Level2HighlightSwaps PROC uses eax ebx ecx edx esi edi

mov edi,Num1
mov ebx,Num2
add edi,offset Array2
add ebx,offset Array2

call Level2PrintIndexes

mov B,11
mov A,30
call TablePosition
invoke PrintString, addr Lines2

mov esi, offset Array2

mov ecx,9

Loop1:
push ecx
push esi

call TablePosition
mov ecx,9
Loop2:

mov edx,offset Spaces
call writeString

mov al, [esi]
movzx edx,al
cmp esi,ebx
je SetExplosionColour
cmp esi,edi
je SetExplosionColour
jmp NotExplosionColour

SetExplosionColour:
call SetCrushedNumberColour
jmp Compare

NotExplosionColour:
call SetColour

Compare:
cmp al,'B'
jz PrintB
cmp al,' '
jz PrintB

call writedec
jmp done

PrintB:
call WriteChar

done:
call SetInitialColour
mov edx,offset Spaces2
call writeString

add esi, Type Array2

LOOP Loop2


pop esi
pop ecx
mov al,'|'
call Writechar
call crlf

call TablePosition
mov edx,offset Lines2
call writeString
call crlf

add esi, 9

LOOP Loop1


ret
Level2HighlightSwaps ENDP
;-----------------------------------------------------------;




;--------------- Hinghlight Bombed Colours ----------------;
Level2HighlightBomb PROC uses eax ebx ecx edx esi edi

call Level2PrintIndexes

mov B,11
mov A,30
call TablePosition
invoke PrintString, addr Lines2

mov esi, offset Array2

mov ecx,9

Loop1:
push ecx
push esi

call TablePosition
mov ecx,9
Loop2:

mov edx,offset Spaces
call writeString

mov al, [esi]
movzx edx,al
cmp bl,al
je SetExplosionColour
cmp esi,edi
je SetExplosionColour
jmp NotExplosionColour

SetExplosionColour:
call SetCrushedNumberColour
jmp Compare

NotExplosionColour:
call SetColour

Compare:
cmp al,'B'
jz PrintB
cmp al,' '
jz PrintB

call writedec
jmp done

PrintB:
call WriteChar

done:
call SetInitialColour
mov edx,offset Spaces2
call writeString

add esi, Type Array2

LOOP Loop2


pop esi
pop ecx
mov al,'|'
call Writechar
call crlf

call TablePosition
mov edx,offset Lines2
call writeString

call crlf
add esi, 9

LOOP Loop1


ret
Level2HighlightBomb ENDP
;-----------------------------------------------------------;




;--------------- If Any Swapped Number is B initiate Bomb----------------;
Level2InitiateBomb PROC

call JumpLines
invoke PrintString, addr Explosion
call ScreenSleep

mov eax,Moves
mov Temp,eax

mov eax, Num1
mov ebx, Num2
add eax,offset Array2
mov esi,eax
add ebx,offset Array2
mov edi,ebx

mov eax,0
mov  al,[esi]
cmp al,'B'
jz BombAddress1
mov eax,0
mov  al,[edi]
cmp al,'B'
jz BombAddress2

BombAddress1:
mov ebx,0
mov ebx,[edi]
mov edi,esi
jmp Start

BombAddress2:
mov ebx,[esi]

Start:
mov esi, offset Array2

call Level2HighlightBomb
call ScreenSleep

mov ecx,9
Loop1:
push ecx
push esi
mov ecx,9
Loop2:
mov dl,[esi]
cmp bl,dl
jnz NotBombNumber

mov eax,1
add Score,eax
mov eax,4
call randomRange
inc eax
mov [esi],al


NotBombNumber:
add esi, 1

Loop Loop2


pop esi
pop ecx
add esi, 9

LOOP Loop1


mov eax,4
call randomRange
inc eax
mov [edi],al

call Level2CheckDuplicates
mov eax,Temp
inc eax
mov Moves,eax

ret
Level2InitiateBomb ENDP



;--------------------------------------------------------------------------;
;--------------------------------------------------------------------------;
;--------------------------------------------------------------------------;







;---------------------  Deplay For Some Seconds    -------------------;
ScreenSleep PROC  uses eax ecx ebx edx esi edi

mov eax,1000
call delay

ret

ScreenSleep ENDP
;--------------------------------------------------------------------------;



;--------------------------------------------------------------------------;






;--------------------------------------------------------------------------;


ConvertScoreToString proc uses eax ebx ecx edx esi edi

mov eax, Score
mov ebx,10
mov esi, offset ScoreToString + 4


mov ecx,5
Loop1:
div bl
push eax
add ah,30h
mov [esi],ah
dec esi
pop eax
mov ah,0

cmp eax,10
jl Done
loop Loop1

Done:
add al,30h
mov [esi],al

ret
ConvertScoreToString endp


;--------------------------------------------------------------------------;

GetHighest PROC uses eax ebx edx

mov eax, Level1Score
mov ebx, Level2Score
mov edx, Level3Score

cmp eax, ebx
ja Compare2ndForA
jmp CheckB

Compare2ndForA:
cmp eax,edx
jna CheckB
mov Score,eax
mov leveltostore, '1'
MOV EDX,Score
jmp Done

CheckB:
cmp ebx, eax
ja Compare2ndForB
jmp CheckC

Compare2ndForB:
cmp ebx,edx
jna CheckC
mov Score,ebx
mov leveltostore, '2'
MOV EDX,Score
jmp Done


CheckC:
cmp edx, eax
ja Compare2ndForC
jmp Done

Compare2ndForC:
cmp edx,ebx
jna Done
mov Score,edx
mov leveltostore, '3'
MOV EDX,Score

Done:

ret
GetHighest ENDP

;--------------------------------------------------------------------------;

;---------------------  Play Level-1   -------------------------;
PlayLevel1 PROC 

	call clrscr
	Invoke InitializeArray1And3 ,Level
	
	
	call  CheckDuplicates

	MOV Score,0
	mov Moves,0

	
	ContinueGame:

	call clrscr
	call SetPosition
	call DisplayPlayerInfo
	call crlf
	INVOKE BOARDLevel1And3,Level

	call MoveInput
	
	cmp Moves,2
	JNZ ContinueGame

	
	call clrscr
	call SetPosition
	call DisplayPlayerInfo
	call crlf
	INVOKE BOARDLevel1And3,Level
	call waitmsg

	mov edx, Score
	mov Level1Score,edx
	call ConvertScoreToString

INVOKE WriteFile, fileHandle,ADDR Level1FileHandling, SIZEOF Level1FileHandling,ADDR bytesWritten,NULL
INVOKE WriteFile, fileHandle,ADDR ScoreToString, SIZEOF ScoreToString,ADDR bytesWritten,NULL
INVOKE WriteFile, fileHandle,ADDR NextLine, SIZEOF NextLine,ADDR bytesWritten,NULL



	inc Level

ret
PlayLevel1 ENDP
;--------------------------------------------------------------------------;




;---------------------  Play Level-2   -------------------------;
PlayLevel2 PROC 
		
		call clrscr
		Invoke InitializeArray2 
		
		
		call  Level2CheckDuplicates


		mov Moves,0
		MOV Score,0
	
		ContinueGame:
		call clrscr
		call SetPosition
		call DisplayPlayerInfo
		call crlf
		INVOKE BOARDLevel2

		call Level2MoveInput
		
		cmp Moves,2
		JNZ ContinueGame

		
		call clrscr
		call SetPosition
		call DisplayPlayerInfo
		call crlf
		INVOKE BOARDLevel2
		call WaitMsg

		mov edx, Score
		mov Level2Score,edx
		call ConvertScoreToString

		INVOKE WriteFile, fileHandle,ADDR Level2FileHandling, SIZEOF Level2FileHandling,ADDR bytesWritten,NULL
		INVOKE WriteFile, fileHandle,ADDR ScoreToString, SIZEOF ScoreToString,ADDR bytesWritten,NULL
		INVOKE WriteFile, fileHandle,ADDR NextLine, SIZEOF NextLine,ADDR bytesWritten,NULL



		inc Level

ret
PlayLevel2 ENDP
;--------------------------------------------------------------------------;




;---------------------  Play Level-3   -------------------------;
PlayLevel3 PROC 

	call clrscr
	Invoke InitializeArray1And3,Level
	
	
	call  CheckDuplicates
	
	mov Score,0
	mov Moves,0
	
	
	ContinueGame:
	call clrscr
	call SetPosition
	call DisplayPlayerInfo
	call crlf
	INVOKE BOARDLevel1And3,Level
	
	call MoveInput


	cmp Moves,2
	JNZ ContinueGame

	
	call clrscr
	call SetPosition
	call DisplayPlayerInfo
	call crlf
	INVOKE BOARDLevel1And3,Level
	call waitmsg

	mov edx, Score
	mov Level3Score,edx
	call ConvertScoreToString

	INVOKE WriteFile, fileHandle,ADDR Level3FileHandling, SIZEOF Level3FileHandling,ADDR bytesWritten,NULL
	INVOKE WriteFile, fileHandle,ADDR ScoreToString, SIZEOF ScoreToString,ADDR bytesWritten,NULL
	INVOKE WriteFile, fileHandle,ADDR NextLine, SIZEOF NextLine,ADDR bytesWritten,NULL



ret
PlayLevel3 ENDP
;------------------------------------------------;



end main