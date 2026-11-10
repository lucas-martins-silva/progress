/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMR2000RP 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i imr2000rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: imr2000rp.p
**
**       DATA....: 
**
**       Objetivo: Contratos a Embarcar
**
**       VERSAO..: 0.00.000 - 
**
******************************************************************************/

{utp/ut-glob.i}
{include/i-rpvar.i}
{imp/imr2000.i}             
{cdp/cd4300.i3}     /* variaveis para desmembrar variaveis livres */
{rep/re1001a.i50}   /* desmembrar atributos livres ordens-embarque */ 

{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}

/***************************Definiá∆o de ParÉmetros *****************************/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var de-val-desp as dec.
DEFINE VARIABLE de-val-me AS DECIMAL    NO-UNDO.

/******************************Definiá∆o de Form *********************************/
{imp/imr2000.i2}

/****************************** L i t e r a i s **********************************/
{utp/ut-liter.i SELEÄ«O * R}
assign c-selecao = trim(return-value).
{utp/ut-liter.i Estabelecimento * L}
assign c-impressao = trim(return-value).
{utp/ut-liter.i CLASSIFICAÄ«O * R}
assign c-classifica = trim(return-value).
{utp/ut-liter.i Relat¢rio_Unificado_de_Drawback * C}
assign c-titulo-relat = trim(return-value).


/*************************Cabeáalho***************************************/

{utp/ut-liter.i Empresa * R}
ASSIGN c-empresa-prin = RETURN-VALUE + ": ".
{utp/ut-liter.i CNPJ * R}
ASSIGN c-empresa-cgc = RETURN-VALUE + ": ".
{utp/ut-liter.i Ato_Concess¢rio_Nr * C}
ASSIGN c-nr-ato-con = trim(RETURN-VALUE) + ": ".

{utp/ut-liter.i DI/RE * R}
assign c-di-re = return-value.
{utp/ut-liter.i Data * R}
assign c-dt-di-re = return-value.
{utp/ut-liter.i NF * R}
assign c-nf = return-value.
{utp/ut-liter.i Data * R}
assign c-dt-nf = return-value.
{utp/ut-liter.i NCM * R}
assign c-class-fisc = return-value.
{utp/ut-liter.i Descr._Mercadoria * R}
assign c-desc-merc = return-value.
{utp/ut-liter.i Peso * R}
assign c-peso = return-value.
{utp/ut-liter.i Quant. * R}
assign c-quant = return-value.
{utp/ut-liter.i Vl._Local_Emb. * R}
assign c-vl-merc = return-value.
{utp/ut-liter.i Vl._Total * R}
assign c-vl-tot = trim(return-value) .
{utp/ut-liter.i DI * R}
assign c-text-1 = return-value.
{utp/ut-liter.i RE * R}
assign c-text-2 = return-value.
/*************************Cabeáalho***************************************/


/****************************** E X E C U Ä « O **********************************/

{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

IF AVAIL empresa THEN
    ASSIGN c-empresa-prin = c-empresa-prin + empresa.nome
           c-empresa-cgc  = c-empresa-cgc + empresa.cgc.

find empresa no-lock 
    where empresa.ep-codigo = tt-param.ep-codigo no-error.
    
assign c-empresa  = (if avail empresa then empresa.nome else "")
       c-programa = "imr2000"
       c-destino  = {varinc/var00002.i 04 tt-param.destino}
       c-vl-tot   = c-vl-tot + " " + string(tt-param.i-moeda). 
       
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
    
    for each tt-pedido-drb:
        delete tt-pedido-drb.
    end.
    
    for each tt-aux-re:
        delete tt-aux-re.
    end.
    
    for each tt-aux-di:
        delete tt-aux-di.
    end.        
    
    for each tt-unificado-re:
        delete tt-unificado-re.
    end.
    
    for each tt-unificado-di:
        delete tt-unificado-di.
    end.
    
    /* Traz descriá∆o da moeda */
    find moeda
        where moeda.mo-codigo = tt-param.i-moeda no-lock no-error.
    if avail moeda then
        assign c-moeda-tot = "(" + moeda.sigla + ")".

    disp c-di-re
         c-dt-di-re 
         c-nf 
         c-dt-nf
         c-class-fisc
         c-peso 
         c-quant 
         c-vl-merc
         c-vl-tot
         c-moeda-tot
         with  width 190 frame f-cabecalho.

    assign cont = 0.

    IF CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-drb-sld-terc" AND funcao.ativo = YES) THEN DO:
        {imp/imr2000.i3} /* Include de tratamento da Suspens∆o   */ 
        {imp/imr2000.i4} /* Include de tratamento da Isená∆o     */
    END.
    ELSE DO:
        {imp/imr2000.i6}
        {imp/imr2000.i7}
        {imp/imr2000.i8}
        {imp/imr2000.i9}
    END.
    
    {imp/imr2000.i5} /* Include de tratamento da Restituiá∆o */

end.

IF CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-drb-sld-terc" AND funcao.ativo = YES) then do:

    /* Impress∆o Notas de Importaá∆o */
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-notas-de-importacao AS CHARACTER FORMAT "X(21)" NO-UNDO.
    {utp/ut-liter.i "Notas_de_Importaá∆o" *}
    ASSIGN c-lbl-liter-notas-de-importacao = TRIM(RETURN-VALUE).
    put c-lbl-liter-notas-de-importacao format "x(20)" at 4 fill("-",108) format "x(108)" skip.

    for each tt-unificado-di:
    
        run cdp/cd0812.p (input 0,
                          input tt-param.i-moeda,
                          input tt-unificado-di.valor,
                          input tt-unificado-di.dat-cotac,
                          output de-val-desp).
    
       disp  tt-unificado-di.declaracao-import
             tt-unificado-di.data-di
             tt-unificado-di.nr-nota-fis
             tt-unificado-di.data-nf
             tt-unificado-di.cod-ncm
             tt-unificado-di.peso
             tt-unificado-di.quantidade
             tt-unificado-di.un
             tt-unificado-di.sigla
             tt-unificado-di.valor
             de-val-desp @ tt-unificado-di.valor-me
             with width 132 frame f-unificado-di.
        put tt-unificado-di.descricao at 63 skip.
    
    end.
    
    /* Impress∆o Notas de Exportaá∆o */ 
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-notas-de-exportacao AS CHARACTER FORMAT "X(21)" NO-UNDO.
    {utp/ut-liter.i "Notas_de_Exportaá∆o" *}
    ASSIGN c-lbl-liter-notas-de-exportacao = TRIM(RETURN-VALUE).
    put skip(2) c-lbl-liter-notas-de-exportacao format "x(20)" at 4 fill("-",108) format "x(108)" skip.
    
    for each tt-unificado-re:
       
        run cdp/cd0812.p (input 0,
                          input tt-param.i-moeda,
                          input tt-unificado-re.valor,
                          input tt-unificado-re.dat-cotac,
                          output de-val-desp).
        
        disp tt-unificado-re.nr-re  
             tt-unificado-re.data-re
             tt-unificado-re.nr-nota-fis 
             tt-unificado-re.data-nf   
             tt-unificado-re.cod-ncm
             tt-unificado-re.peso
             tt-unificado-re.quantidade
             tt-unificado-re.un
             tt-unificado-re.sigla
             tt-unificado-re.valor
             de-val-desp @ tt-unificado-re.valor-me 
             with width 132 frame f-unificado-re.
             
        put tt-unificado-re.descricao at 63 skip.
    
    end.

end.

{include/i-rpclo.i}
RETURN "OK":U.

/* FIM  */


