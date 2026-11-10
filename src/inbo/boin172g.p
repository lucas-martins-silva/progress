/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172G 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN172G MUT}
&ENDIF

/******************************************************************************
**
** TDIN172E - Eliminaá∆o das tabelas do banco mgmnt 
**
*******************************************************************************/

def input param p-it-codigo as char format "x(16)" no-undo.
def input param p-modulo-pi as log no-undo.

if  p-modulo-pi = yes then do:
    find mi-pl-item 
        where mi-pl-item.it-codigo = p-it-codigo EXCLUSIVE-LOCK no-error.

    if  avail mi-pl-item then do:
        find first it-periodo
             where it-periodo.it-codigo = mi-pl-item.it-codigo no-lock no-error.

        /*** Se n∆o foi calculado nada para o item planejado pode ser eliminado **/
        if  not avail it-periodo then do:
            if  available mi-pl-item then
                delete mi-pl-item.  
        end.   
    end.
end.
 
/* Fim do Programa */
