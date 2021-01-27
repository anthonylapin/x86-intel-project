X_ARR_SIZE      equ  200
Y_ARR_SIZE      equ  200

section .bss
col_size        resd    1
row_size        resd    1

x_arr_index     resd    1
y_arr_index     resd    1

x               resd    1
y               resd    1

marker_width    resd    1
marker_height   resd    1

section .text
    global  func

func:
    push    ebp
    mov     ebp, esp

    ; set col size & row size
    call    getColSize
    mov     dword [col_size], eax
    call getRowsSize
    mov dword [row_size], eax

    ; set initial x_arr_index and y_arr_index to 0
    mov dword [x_arr_index], 0 
    mov dword [y_arr_index], 0

    mov ecx, DWORD [ebp+12] ; address of x_arr array
    mov eax, dword [col_size]
    mov dword [ecx], eax

    mov ecx, DWORD [ebp+16] ; address of x_arr array
    mov eax, dword [row_size]
    mov dword [ecx], eax

    ; iterate through bmp
    mov dword [y], 0
    rowLoop:
        mov dword [x], 0
        colLoop:
            call findWidth
            call findHeight

            mov eax, dword [marker_width]
            mov edx, 2
            mul edx
            mov edx, dword [marker_height]

            cmp eax, edx
            jne continue

            cmp eax, 0
            je continue
            cmp edx, 0
            je continue

            ; ; check if x_pos and y_pos is < 50
            mov eax, [x_arr_index]
            cmp eax, X_ARR_SIZE
            jge continue

            mov eax, [y_arr_index]
            cmp eax, Y_ARR_SIZE
            jge continue

            call setMarker

            continue:
            add dword [x], 1
            ; check if x < col_size
            mov eax, dword [x]
            cmp eax, dword [col_size]
            jl colLoop

        add dword [y], 1
        ; check if y < col_size
        mov eax, dword [y]
        cmp eax, dword [row_size]
        jl rowLoop

            
    ; terminate program
    terminate_program:
    mov eax, 0 ; return 0
    pop ebp
    ret

findHeight:
; x - x_0 coordinate, y - y_0 coordinate
    mov dword [marker_height], 0 ; initially 0
    findHeightLoop:
        mov ecx, dword [x]
        mov edx, dword [y]
        sub edx, dword [marker_height]
        
        cmp edx, -1
        je exitfindHeightLoop

        call getPixel

        cmp eax, 0
        jne exitfindHeightLoop

        ; else increment marker_height & go over again
        add dword [marker_height], 1
        jmp findHeightLoop

    exitfindHeightLoop:
        ret

findWidth:
; x - x_0 coordinate, y - y_0 coordinate
    mov dword [marker_width], 0 ; initially 0
    findWidthLoop:
        mov ecx, dword [x]
        sub ecx, dword [marker_width] ; x = x0 - width
        mov edx, dword [y]

        ; check if x is outside the bounds
        cmp ecx, -1
        je exitFindWidthLoop

        call getPixel

        cmp eax, 0
        jne exitFindWidthLoop

        ; else increment marker_width & go over again
        add dword [marker_width], 1

        jmp findWidthLoop

    exitFindWidthLoop:
        ret


setMarker:
; x - x coordinate of marker, y - y coordinate of marker

    mov ecx, DWORD [ebp+12] ; address of x_arr array
    mov eax, dword [x_arr_index]
    add ecx, eax
    mov eax, dword [x]
    mov dword [ecx], eax

    mov ecx, DWORD [ebp+16] ; address of y_arr array
    mov eax, dword [y_arr_index]
    add ecx, eax
    mov eax, dword [y]
    mov dword [ecx], eax

    add dword [x_arr_index], 4
    add dword [y_arr_index], 4

    ret

getColSize:
; no args
; return - eax
    mov ecx, DWORD [ebp+8]
    mov eax, dword [ecx+18]
    ret

getRowsSize:
; args: no args
; return - eax
    mov ecx, DWORD [ebp+8]
    mov eax, dword [ecx+22]
    ret

getImageOffset:
    mov ecx, dword [ebp+8]
    mov eax, dword [ecx+10]
    ret

getPixel:
; pixel = baseAddr + (rowIndex * colSize + colIndex) * 3
; args: colIndex - ecx, rowIndex - edx
    mov eax, dword [col_size]
    mul edx

    add eax, ecx
    mov edx, 3
    mul edx

    mov edx, eax
    call getImageOffset
    mov ecx, edx
    add eax, ecx

    mov ecx, DWORD [ebp+8]
    add ecx, eax
    mov eax, dword [ecx]

    ret
