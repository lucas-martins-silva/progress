/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT002 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEUT002 MUT}
&ENDIF


/********************************************************************************
** Programa : aneut002.p
** Fun‡Æo   : Processador de Fila de Entrada
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

input-output stream s1 through "java com.neogrid.arch.adapter.Server" unbuffered no-convert.

repeat:
    pause 2 no-message.
    import stream s1 unformatted c-linha.
    if  c-linha = chr(1)
    or  c-linha = chr(2) then do:
        if  ms = 0 then do:
            assign dt = string(today,"99/99/9999") + " " + string(TIME,"HH:MM:SS")
                   id = next-value(sq_ngmessagequeue).
        end.
        assign ms = ms + 1.
        create NGMessageQueue.
        assign NGMessageQueue.NGMessageQueueName     = ""
               NGMessageQueue.NGMessageQueueID       = id
               NGMessageQueue.NGMessageQueueSequence = ms
               NGMessageQueue.DateTime               = dt
               NGMessageQueue.XMLMessage             = c-message.
        if  c-linha = chr(2) then do:
            for each NGMessageQueue EXCLUSIVE-LOCK
                where NGMessageQueue.NGMessageQueueName = ""
                and   NGMessageQueue.NGMessageQueueID   = id:
                
                assign NGMessageQueue.NGMessageQueueName = "IN".
            end.
            assign ms = 0.
        end.
        put stream s1 unformatted "OK" chr(13) chr(10).
        assign c-message = "".
    end.
    else do:
        assign c-message = c-message + c-linha + chr(13) + chr(10).
    end.
end.
        
input-output stream s1 close.
