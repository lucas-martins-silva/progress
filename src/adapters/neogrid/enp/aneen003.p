/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEEN003 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneen003 MAN}
&ENDIF

/*******************************************************************************
**
**     Programa: aneen003.P
**
**     Data....: JUNHO DE 2001
**
**     Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**     Objetivo: Envio de itens para o NeoGrid e-CS
**
*******************************************************************************/

/*** Prepara para emissÆo dos dados do item para adapter EAI***/

/********************************************************************************************
** Temp-table tt-from-role : Temp-table que vai possuir as informa‡äes 
** referentes a origem da mensagem.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen003.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen003.i} 

/********************************************************************************************
** Temp-table tt-from-role : Temp-table que vai possuir as informa‡äes 
** referentes ao destinat rio da mensagem.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen002.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen002.i} 

/********************************************************************************************
** Temp-table tt-item : Temp-table que vai possuir as informa‡äes 
** referentes ao cadastro de Itens.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen001.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen001.i} 

{cdp/cd0503.i1}

/***/
/*Inserido conforme engenharia "Eng_Repasse_Neogrid_EMS_204" */


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "").
RUN pi-seta-titulo IN h-acomp (INPUT "Preparando dados para gera‡Æo do XML.").

/*Inserido conforme engenharia "Eng_Repasse_Neogrid_EMS_204" */
/***/
     
FIND FIRST w-itens NO-ERROR.
ASSIGN l-primeira = YES.
IF NOT AVAIL w-itens THEN DO:
   FOR EACH item
       WHERE item.ge-codigo     >= i-grupo-ini   
         AND item.ge-codigo     <= i-grupo-fim
         AND item.it-codigo     >= c-item-ini
         AND item.it-codigo     <= c-item-fim
         AND item.fm-codigo     >= c-familia-ini
         AND item.fm-codigo     <= c-familia-fim
         AND item.desc-item     >= c-descr-ini
         AND item.desc-item     <= c-descr-fim
         AND item.inform-compl  >= c-inf-ini
         AND item.inform-compl  <= c-inf-fim
         AND item.data-implant  >= d-data-ini
         AND item.data-implant  <= d-data-fim
         AND item.fm-cod-com    >= c-fam-com-ini
         AND item.fm-cod-com    <= c-fam-com-fim
         AND ((item.compr-fabric = 1  AND l-comprado  = true)
          OR  (item.compr-fabric = 2  AND l-fabricado = true))
         AND ((l-obsol1 AND item.cod-obsoleto = 1)
          OR  (l-obsol2 AND item.cod-obsoleto = 2)
          OR  (l-obsol3 AND item.cod-obsoleto = 3) 
          OR  (l-obsol4 AND item.cod-obsoleto = 4)) NO-LOCK  
       ON STOP UNDO, LEAVE:
        RUN pi-acompanhar IN h-acomp (INPUT item.it-codigo).

        /* Alterado conforme engenharia "Eng_Repasse_Neogrid_EMS_204" */
        /*
        disp item.it-codigo.
        */
        /*** Cria item para envio ao adapter EAI ***/
        {adapters/neogrid/enp/aneen004.i}
           
   END.   
END.
ELSE DO:
    FOR EACH w-itens 
        ON STOP UNDO, LEAVE:
        
        FIND item 
            WHERE item.it-codigo = w-itens.it-codigo  NO-LOCK NO-ERROR.
          
        RUN pi-acompanhar IN h-acomp (INPUT item.it-codigo).

        /*** Cria item para envio ao adapter EAI ***/
        {adapters/neogrid/enp/aneen004.i}
    END.   
END.

/*** EmissÆo dos itens para adapter EAI***/

CREATE tt-from-role.
ASSIGN tt-from-role.local-orig = "1".

CREATE tt-to-role.
ASSIGN tt-to-role.local-dest = "1".

/* Inserido conforme engenharia "Eng_Repasse_Neogrid_EMS_204"*/
RUN pi-seta-titulo IN h-acomp (INPUT "Enviando XML.").

RUN adapters/neogrid/enp/aneen001.p (INPUT TABLE tt-item,
                                     INPUT TABLE tt-from-role,
                                     INPUT TABLE tt-to-role).

RUN pi-finalizar IN h-acomp.
