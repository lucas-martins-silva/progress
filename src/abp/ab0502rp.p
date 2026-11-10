/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0502RP 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0502rp MAB}
&ENDIF


{include/i_fnctrad.i}
/********************************************************************************
**
**       PROGRAMA: AB0502RP.p
**
**       DATA....: Setembro de 2003
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: 
**       Versao..: 2.00.00.004
**
********************************************************************************/

/** Definicao das temp-tables para recebimento dos parametros **/

{abp/ab0502.i}  

/* Recebimento de parametros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.


DISABLE TRIGGERS FOR LOAD OF mab-item-abastec.
DISABLE TRIGGERS FOR LOAD OF mab-control-bomba.
DISABLE TRIGGERS FOR LOAD OF mab-bomba.
DISABLE TRIGGERS FOR LOAD OF mab-posto.
define variable lAchou     as logical no-undo.


create tt-param.
raw-transfer raw-param to tt-param.

/* Include padroes para variaveis de relatorio */
{include/i-rpvar.i}

/* Include padrao para output de relatorios */
{include/i-rpout.i }
view frame f-cabec.
view frame f-rodape.

ASSIGN l-Insere        =     tt-param.l-Insere      
       d-data-ini      =     tt-param.d-data-ini    
       d-data-fim      =     tt-param.d-data-fim    
       c-hora-ini      =     tt-param.c-hora-ini    
       c-hora-fim      =     tt-param.c-hora-fim    
       c-bomba-ini     =     tt-param.c-bomba-ini   
       c-bomba-fim     =     tt-param.c-bomba-fim   
       c-posto-ini     =     tt-param.c-posto-ini   
       c-posto-fim     =     tt-param.c-posto-fim    
       i-cod-emp-ini   =     tt-param.i-cod-emp-ini 
       i-cod-emp-fim   =     tt-param.i-cod-emp-fim. 

/* Include com a definicao da frame de cabecalho e rodape */
{include/i-rpcab.i }    

/* Bloco principal do programa */
for first param-global fields(empresa-prin) no-lock:
    for FIRST empresa 
        WHERE empresa.ep-codigo = param-global.empresa-prin no-lock:
        ASSIGN c-empresa = empresa.razao-social.
    end.
end.

find first tt-param.

{utp/ut-liter.i Comparativo_Leitura_de_Bombas_x_Abastecimentos * L}
assign c-programa     = "AB/0502"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = return-value
       c-sistema      = "".

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo").

/*****Includes para Display dos Relat¢rios***/
CASE tt-param.classifica:
    WHEN 1 THEN DO:
        RUN pi-empresa.
        {abp/ab0502.i2}
    END.
    WHEN 2 THEN DO:
        RUN pi-posto.
        {abp/ab0502.i3} 
    END.
    WHEN 3 THEN DO:
        RUN pi-bomba.
        {abp/ab0502.i4} 
    END.
END CASE.
         
/*Fechamento do output do relat¢rio*/
run pi-finalizar in h-acomp.
view frame f-cabec.
view frame f-rodape.
 
 
if  tt-param.parametro = YES then do: 
     PUT SKIP (1).
     {utp/ut-liter.i PAR¶METROS * C}
     PUT  unformatted skip(1) return-value format "x(30)" AT 23 skip.
     form 
          c-texto-1                 colon 33
          l-Insere                  colon 33 
     with stream-io   overlay side-labels row 014 frame f-imp-par.
     /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par:HANDLE).
     

   
     {utp/ut-liter.i Insere_Quebra_de_P gina  * L}
     assign   l-Insere:label in frame f-imp-par = return-value.
     {utp/ut-liter.i Relat¢rio  * L}
     assign   c-texto-1:label in frame f-imp-par = return-value.
     assign         c-texto-1 = tt-param.desc-considera .

     {utp/ut-liter.i Sim/NÆo}
     assign  l-Insere:FORMAT in frame f-imp-par = return-value.    
               
     disp 
     c-texto-1
     l-Insere     
     with frame f-imp-par.

     {utp/ut-liter.i SELE€ÇO * C}
     PUT  unformatted skip(1) return-value format "x(30)" AT 26 skip.
     disp 
      i-cod-emp-ini     colon 33  "|< >|"  at 57 i-cod-emp-fim no-label
      c-posto-ini       colon 33  "|< >|"  at 57 c-posto-fim   no-label
      c-bomba-ini       colon 33  "|< >|"  at 57 c-bomba-fim   no-label
      d-data-fim        colon 33  "|< >|"  at 57 d-data-ini    no-label
      c-hora-ini        colon 33  "|< >|"  at 57 c-hora-fim    no-label
      with stream-io side-labels overlay row 030 frame f-imp-sel.

   {utp/ut-liter.i CLASSIFICA€ÇO * R}
   PUT  unformatted skip(1) return-value format "x(30)" AT 21 skip.
    disp  desc-classifica  AT 35 NO-LABEL 
          with stream-io side-labels overlay row 030 frame f-imp-cla.

   {utp/ut-liter.i IMPRESSÇO * C}
    PUT  unformatted skip(1) return-value format "x(30)" AT 25 skip.
   {utp/ut-liter.i Destino: * L}
   put unformatted skip "    " return-value format "x(10)" AT 23 v-cod-destino-impres " - " tt-param.arquivo format "x(40)".
   {utp/ut-liter.i Execu‡Æo: * L}
   put  unformatted skip "    " return-value format "x(12)" AT 22 if i-num-ped-exec-rpw = 0 then " On-Line" else " Batch".
   {utp/ut-liter.i Usu rio: * L}
   put  unformatted skip "    " return-value format "x(10)" AT 23 tt-param.usuario.

end.

{include/i-rpclo.i }

return "OK":U.
