/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0201B 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BH0201B MBH}
&ENDIF


/*******************************************************************************
**
**  Programa: BH0201B.P - Faz a transferˆncia do registro para o arquivo de 
**                        hist¢ricos. 
**                        COTA€åES
**
*******************************************************************************/
/*Defini‡Æo include pr‚-processador release */
{cdp/cdcfgdis.i} 

/* ============================ Input Parameters ============================ */
define input parameter c-nome-arq as char  no-undo.
define input parameter rw-arqmov  as rowid no-undo.


/* =============================== Main Block =============================== */
&IF '{&bf_dis_versao_ems}' < "2.04" &THEN
    case c-nome-arq:
         when "cot-ped-v" then do:
             find movdis.cot-ped-v where rowid(movdis.cot-ped-v) = rw-arqmov no-lock no-error.
             {bhp/bh9800.i &area=dis &arqmov=cot-ped-v}	
         end.
         when "cot-ped-i" then do:
             find movdis.cot-ped-i where rowid(movdis.cot-ped-i) = rw-arqmov no-lock no-error.
             {bhp/bh9800.i &area=dis &arqmov=cot-ped-i}	
         end.
         when "cot-nar-it" then do:
             find movdis.cot-nar-it where rowid(movdis.cot-nar-it) = rw-arqmov no-lock no-error.
             {bhp/bh9800.i &area=dis &arqmov=cot-nar-it}
         end.
    end case.     
&ENDIF
