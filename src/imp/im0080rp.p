/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0080RP 2.00.00.012}  /*** "010012" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0080rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: im0080rp.p
**
**       DATA....: Novembro DE 2000
**
**       Objetivo: Contabiliza‡Æo de Material em Trƒnsito
**
**       VERSAO..: 2.00.00.000 - Anderson
**
******************************************************************************/
{utp/ut-glob.i}
{include/i-rpvar.i}
{imp/im0080.i1} /* Defini‡Æo de temp table */
{imp/im0080.i2} /* Defini‡Æo de forms */

{cdp/cd4300.i3}
{rep/re1001a.i50}  /* variaveis e informacoes utilizadas pelo re1001a.i51 */    

{include/tt-edit.i} /*Defini‡Æo tt-editor*/
{include/pi-edit.i}

/***************************Defini‡Æo de Parƒmetros *****************************/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.
/****************************** L i t e r a i s **********************************/
{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Data_Transa‡Æo * L}
assign tt-param.data-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Considera_Desembarque_Parcial * L}
assign tt-param.l-desemb-parcial:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Contabiliza‡Æo_Material_em_Trƒnsito * L}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i Embarques_Contabilizados * L}
assign c-titulo-contab = trim(return-value).
{utp/ut-liter.i Embarques_nÆo_Contabilizados * L}
assign c-titulo-erro = trim(return-value).
{utp/ut-liter.i Embarque * L}
assign tt-embarque-contab.embarque:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i Est * L}
assign tt-embarque-contab.cod-estabel:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i Emp * L}
assign tt-embarque-contab.ep-codigo:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i Esp * L}
assign tt-embarque-contab.cod-esp:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i S‚rie * L}
assign tt-embarque-contab.serie:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i Documento * L}
assign tt-embarque-contab.nr-docto:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i /P * L}
assign tt-embarque-contab.parcela:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i Fornec * L}
assign tt-embarque-contab.cod-fornec:label in frame f-layout1 = trim(return-value).
{utp/ut-liter.i Est * L}
assign c-estab = trim(return-value).
{utp/ut-liter.i Embarque * L}
assign c-embarq = trim(return-value).
{utp/ut-liter.i C¢digo * L}
assign c-erro = trim(return-value).
{utp/ut-liter.i Mensagem * L}
assign c-mens = trim(return-value).
{utp/ut-liter.i Sim/NÆo * L}
assign c-sim-nao = trim(return-value).


/****************************** E X E C U € Ç O **********************************/
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.


RUN imp/im0080.p (input  v_cod_grp_usuar_lst,
                  input  v_cod_usuar_corren,
                  input  tt-param.data-ini,
                  input  tt-param.data-fim,
                  input  i-ep-codigo-usuario,
                  input  "",
                  input  "",
                  input  ?, /*data para contabiliza‡ä material em transito, para embarque com periodos ja fechados.*/
                  input  tt-param.l-desemb-parcial,
                  input-output table tt-retorno-erro,
                  output table tt-embarque-contab).

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa = "im0080"
       c-destino  = {varinc/var00002.i 04 tt-param.destino}. 
       
{cdp/cd-rpout.i}   /* include customizada Comex */
view frame f-cabec.
view frame f-rodape.
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
    
    find first tt-embarque-contab no-error.
    if avail tt-embarque-contab then do:
        disp c-titulo-contab with frame f-tit1.
        for each tt-embarque-contab
            break by tt-embarque-contab.cod-estabel
                  by tt-embarque-contab.embarque:
            disp tt-embarque-contab.cod-estabel 
                 tt-embarque-contab.embarque 
                 tt-embarque-contab.ep-codigo         
                 tt-embarque-contab.cod-esp             
                 tt-embarque-contab.serie          
                 tt-embarque-contab.nr-docto         
                 tt-embarque-contab.parcela           
                 tt-embarque-contab.cod-fornec  with frame f-layout1.
             
             if last-of(tt-embarque-contab.embarque) then put skip(1).
             
             down with frame f-layout1.
        end.    
    end.   
       
    find first tt-retorno-erro no-error.
    if avail tt-retorno-erro then do:      
       disp c-titulo-erro with frame f-tit2.
       disp c-estab c-embarq c-erro c-mens with frame f-label-erro.

       for each tt-retorno-erro
            break by tt-retorno-erro.cod-estabel
                  by tt-retorno-erro.embarque:
            if first-of(tt-retorno-erro.embarque) THEN
               disp tt-retorno-erro.cod-estabel tt-retorno-erro.embarque with frame f-layout2.

            run pi-print-editor (input tt-retorno-erro.mensagem, 100).

            for each tt-editor:
                if tt-editor.linha = 1 then do:
                    disp tt-retorno-erro.cod-erro
                         tt-editor.conteudo @ tt-retorno-erro.mensagem
                         with down frame f-layout2.   
                         down with frame f-layout2.
                end.
                else
                    put unformatted tt-editor.conteudo at 34 skip.
            end.

       end.
    end.
       
END.
if  page-number > 0 then page.
hide frame f-cabec-colum.
if tt-param.parametro = yes then do:
   assign tt-param.l-desemb-parcial:format in frame f-parametros = c-sim-nao.
   disp c-selecao
        tt-param.data-ini
        tt-param.data-fim
        tt-param.l-desemb-parcial
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.
   down with frame f-parametros.
end.
{include/i-rpclo.i}


/* FIM  */
