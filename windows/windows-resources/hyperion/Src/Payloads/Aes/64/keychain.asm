;creates the round keys in keychain_ptr
if defined AES128
proc createKeyChain keychain_ptr:QWORD, sbox_ptr:QWORD,\
                    rcon_ptr:QWORD

     mov [keychain_ptr],rcx
     mov [sbox_ptr],rdx
     mov [rcon_ptr],r8
     push r12
     push r13
     push rbx
     sub rsp,8

     mov r12, ROW_SIZE-1 ;rcx
     mov r13, 1          ;rdx

key_schedule_round:
     ;-------------------
     ;get current column, apply key schedule core and
     ;xor the result with ecx-ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr], r12
     ;shift rows
     rol eax,8
     ;substitute with sbox
     fastcall subBytes, rax, [sbox_ptr]
     ;xor with rcon
     fastcall xorRcon, rax, [rcon_ptr], r13
     inc r13
     ;xor with column at index-ROW_SIZE-1
     mov rbx,rax
     push r12 ;TODO: fix stack alignment
     sub r12,ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr],r12
     pop r12
     xor rax,rbx
     ;store at index+1
     inc r12
     fastcall storeColumn, rax, [keychain_ptr], r12
     ;-------------------

     ;-------------------
     ;three times: get current column and
     ;xor it with ecx-ROW_SIZE-1
     rept 3{
          fastcall loadColumn, [keychain_ptr], r12 ;can be removed
          mov rbx, rax
          push r12 ;TODO: fix stack alignment
          sub r12,ROW_SIZE-1
          fastcall loadColumn, [keychain_ptr],r12
          pop r12
          xor rax,rbx
          inc r12
          fastcall storeColumn, rax, [keychain_ptr], r12
     }
     ;-------------------

     ;check for end of keychain generation
     cmp r12, EXTENDED_KEY_SIZE/COLUMN_SIZE - 1
     jne key_schedule_round

     add rsp,8
     pop rbx
     pop r13
     pop r12
     ret
endp
end if

if defined AES192
proc createKeyChain keychain_ptr:QWORD, sbox_ptr:QWORD,\
                    rcon_ptr:QWORD

     mov [keychain_ptr],rcx
     mov [sbox_ptr],rdx
     mov [rcon_ptr],r8
     push r12
     push r13
     push rbx
     sub rsp,8

     mov r12, ROW_SIZE-1 ;rcx
     mov r13, 1          ;rdx

key_schedule_round:
     ;-------------------
     ;get current column, apply key schedule core and
     ;xor the result with r12-ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr], r12
     ;shift rows
     rol eax,8
     ;substitute with sbox
     fastcall subBytes, rax, [sbox_ptr]
     ;xor with rcon
     fastcall xorRcon, rax, [rcon_ptr], r13
     inc r13
     ;xor with column at index-ROW_SIZE-1
     mov rbx,rax
     push r12 ;TODO: fix stack alignment
     sub r12,ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr],r12
     pop r12
     xor rax,rbx
     ;store at index+1
     inc r12
     fastcall storeColumn, rax, [keychain_ptr], r12
     ;-------------------

     ;-------------------
     ;three times: get current column and
     ;xor it with ecx-ROW_SIZE-1
     rept 3{
          fastcall loadColumn, [keychain_ptr], r12 ;can be removed
          mov rbx, rax
          push r12 ;TODO: fix stack alignment
          sub r12,ROW_SIZE-1
          fastcall loadColumn, [keychain_ptr],r12
          pop r12
          xor rax,rbx
          inc r12
          fastcall storeColumn, rax, [keychain_ptr], r12
     }
     ;-------------------

     ;check for end of keychain generation
     cmp r12, EXTENDED_KEY_SIZE/COLUMN_SIZE - 1
     je exit_key_schedule_round

     ;-------------------
     ;two times: get current column and
     ;xor it with ecx-ROW_SIZE-1
     rept 2{
          fastcall loadColumn, [keychain_ptr], r12 ;can be removed
          mov rbx, rax
          push r12 ;TODO: fix stack alignment
          sub r12,ROW_SIZE-1
          fastcall loadColumn, [keychain_ptr],r12
          pop r12
          xor rax,rbx
          inc r12
          fastcall storeColumn, rax, [keychain_ptr], r12
     }
     ;-------------------

     jmp key_schedule_round

exit_key_schedule_round:
     add rsp,8
     pop rbx
     pop r13
     pop r12
     ret
endp
end if

if defined AES256
proc createKeyChain keychain_ptr:QWORD, sbox_ptr:QWORD,\
                    rcon_ptr:QWORD

     mov [keychain_ptr],rcx
     mov [sbox_ptr],rdx
     mov [rcon_ptr],r8
     push r12
     push r13
     push rbx
     sub rsp,8

     mov r12, ROW_SIZE-1 ;rcx
     mov r13, 1          ;rdx

key_schedule_round:
     ;-------------------
     ;get current column, apply key schedule core and
     ;xor the result with ecx-ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr], r12
     ;shift rows
     rol eax,8
     ;substitute with sbox
     fastcall subBytes, rax, [sbox_ptr]
     ;xor with rcon
     fastcall xorRcon, rax, [rcon_ptr], r13
     inc r13
     ;xor with column at index-ROW_SIZE-1
     mov rbx,rax
     push r12 ;TODO: fix stack alignment
     sub r12,ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr],r12
     pop r12
     xor rax,rbx
     ;store at index+1
     inc r12
     fastcall storeColumn, rax, [keychain_ptr], r12
     ;-------------------

     ;-------------------
     ;three times: get current column and
     ;xor it with ecx-ROW_SIZE-1
     rept 3{
          fastcall loadColumn, [keychain_ptr], r12 ;can be removed
          mov rbx, rax
          push r12 ;TODO: fix stack alignment
          sub r12,ROW_SIZE-1
          fastcall loadColumn, [keychain_ptr],r12
          pop r12
          xor rax,rbx
          inc r12
          fastcall storeColumn, rax, [keychain_ptr], r12
     }
     ;-------------------

     ;check for end of keychain generation
     cmp r12, EXTENDED_KEY_SIZE/COLUMN_SIZE - 1
     je exit_key_schedule_round

     ;-------------------
     ;one times: get current column, subsitute with
     ;sbox and xor it with ecx-ROW_SIZE-1
     ;three times: get current column and
     ;xor it with ecx-ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr], r12 ;can be removed
     fastcall subBytes, rax, [sbox_ptr]
     mov rbx, rax
     push r12 ;TODO: fix stack alignment
     sub r12,ROW_SIZE-1
     fastcall loadColumn, [keychain_ptr],r12
     pop r12
     xor rax,rbx
     inc r12
     fastcall storeColumn, rax, [keychain_ptr], r12
     ;three times
     rept 3{
          fastcall loadColumn, [keychain_ptr], r12 ;can be removed
          mov rbx, rax
          push r12 ;TODO: fix stack alignment
          sub r12,ROW_SIZE-1
          fastcall loadColumn, [keychain_ptr],r12
          pop r12
          xor rax,rbx
          inc r12
          fastcall storeColumn, rax, [keychain_ptr], r12
     }
     ;-------------------

     jmp key_schedule_round

exit_key_schedule_round:
     add rsp,8
     pop rbx
     pop r13
     pop r12
     ret
endp
end if

;store a column at column_index in keychain
proc storeColumn column:QWORD, keychain_ptr:QWORD, column_index:QWORD
     mov [column], rcx
     mov [keychain_ptr],rdx
     mov [column_index],r8

     ;create pointer to first byte of the column
     ;and store column there
     mov rax, [column_index]
     mov r9, COLUMN_SIZE
     mul r9
     add rax, [keychain_ptr]
     mov rcx, [column]
     mov [rax], ecx

     ret
endp

;xor key dword with (rcon(index) 00 00 00)
proc xorRcon key:QWORD, rcon_ptr:QWORD, rcon_index:QWORD
     push rbx ;leaf function

     mov rax,r8 ; [rcon_index]
     mov rbx,rdx; [rcon_ptr]
     xlatb
     shl rax,24
     xor eax,ecx ;[key]

     pop rbx
     ret
endp

;returns in eax the column at column_index in the key chain
proc loadColumn keychain_ptr:QWORD, column_index:QWORD
     ;create pointer to first byte of the colum
     mov rax, rdx ;[column_index]
     mov r8, COLUMN_SIZE
     mul r8
     add rax, rcx ;[keychain_ptr]
     ;return dword and exit
     mov eax,[rax]

     ret
endp

;substitute subkey's bytes with the sbox
proc subBytes subkey:QWORD, sbox_ptr:QWORD
     push rbx ;leaf function

     mov rax,rcx ;[subkey]
     mov rbx,rdx ;[sbox_ptr]
     xlatb
     ror eax, 8
     xlatb
     ror eax, 8
     xlatb
     ror eax, 8
     xlatb
     ror eax, 8

     pop rbx
     ret
endp
