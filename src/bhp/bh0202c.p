/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0202C 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BH0202C MBH}
&ENDIF


/*******************************************************************************
**
**  Programa: BH0202A.C - Faz a transferˆncia do registro do arquivo de 
**                        hist¢ricos para o arquivo de movimento.
**                        COTA€åES
**
*******************************************************************************/

/*Defini‡Æo include pr‚-processador release */
{cdp/cdcfgdis.i} 

/* ============================ Input Parameters ============================ */
define input parameter c-nome-arq as char  no-undo.
define input parameter rw-arqmov  as rowid no-undo.


/* =============================== Main Block =============================== */
case c-nome-arq:
     &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
        when "cot-ped-v" then do:
            find hisdis.cot-ped-v where rowid(hisdis.cot-ped-v) = rw-arqmov no-lock no-error.
            {bhp/bh9801.i &area=dis &arqmov=cot-ped-v}	
        end.
        when "cot-ped-i" then do:
            find hisdis.cot-ped-i where rowid(hisdis.cot-ped-i) = rw-arqmov no-lock no-error.
            {bhp/bh9801.i &area=dis &arqmov=cot-ped-i}	
        end.
        when "cot-nar-it" then do:
            find hisdis.cot-nar-it where rowid(hisdis.cot-nar-it) = rw-arqmov no-lock no-error.
            {bhp/bh9801.i &area=dis &arqmov=cot-nar-it}
        end.
        when "cot-ent" then do:
            find hisdis.cot-ent where rowid(hisdis.cot-ent) = rw-arqmov no-lock no-error.
            {bhp/bh9801.i &area=dis &arqmov=cot-ent}
        end.
        when "cot-desconto" then do:
            find hisdis.cot-desconto where rowid(hisdis.cot-desconto) = rw-arqmov no-lock no-error.
            {bhp/bh9801.i &area=dis &arqmov=cot-desconto}
        end.
     &ENDIF   
     when "con-pges" then do:	
         find hisdis.con-pges where rowid(hisdis.con-pges) = rw-arqmov no-lock no-error.
         {bhp/bh9801.i &area=dis &arqmov=con-pges}
     end.
end case.     
