/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT003 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEUT003 MUT}
&ENDIF


/********************************************************************************
** Programa : aneut003.p
** Fun‡Æo   : Processador de Fila de Sa¡da
** Data     : 05/2000
** Autor    : Neogrid
********************************************************************************/

def stream s1.

def var i-ind     as integer.
def var c-linha   as char.
def var c-message as char.
def var dt        as char.
def var id        as integer.
def var ms        as integer.

input-output stream s1 through "java com.neogrid.arch.adapter.NGSender" unbuffered no-convert.

repeat:
    pause 2 no-message.
    import stream s1 unformatted c-linha.
    if  c-linha = chr(3) then do:
        for first NGMessageQueue
            where NGMessageQueue.NGMessageQueueName = "OUT"
            and   NGMessageQueue.Done               = FALSE NO-LOCK
            by NGMessageQueueID:
            put stream s1 unformatted NGMessageQueueID chr(13) chr(10).
        end.
        put stream s1 unformatted chr(3) chr(13) CHR(10).
        assign c-message = "".    
    end.
    else do:
        if  c-linha = chr(4) then do:
            for each ngmessagequeue
                where NGMessageQueue.NGMessageQueueName = "OUT"
                and   NGMessageQueue.NGMessageQueueID   = integer(trim(c-message)) no-lock:
                put stream s1 unformatted XMLMessage.
            end.
            put stream s1 unformatted chr(13) chr(10).
            put stream s1 unformatted chr(4) chr(13) CHR(10).
            assign c-message = "".    
        end.
        else do:
            if  c-linha = chr(5) then do:
                def var l-ok as logical.
                for each  ngmessagequeue
                    where NGMessageQueue.NGMessageQueueName = "OUT"
                    and   NGMessageQueue.NGMessageQueueID   = integer(trim(c-message)) exclusive-lock:
                    assign NGMessageQueue.DONE = true.
                    assign l-ok = yes.
                end.
                if  l-ok = yes then
                    put stream s1 unformatted "OK" chr(13) chr(10).
                else
                    put stream s1 unformatted "NOK" chr(13) chr(10).

                assign c-message = "".    
            end.
            else
                assign c-message = c-message + c-linha + chr(13) + chr(10).
        end.
    end.
end.
        
input-output stream s1 close.
