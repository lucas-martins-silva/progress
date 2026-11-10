/*----------------------------------------------------------------------------------

    DEFINI€åES TEMP-TABLE

----------------------------------------------------------------------------------*/
DEFINE TEMP-TABLE ttDCe NO-UNDO
     /*Chave EMS*/
     FIELD CodEstabelDCe    AS CHARACTER INITIAL ?
     FIELD SerieDCe         AS CHARACTER INITIAL ?
     FIELD NrDCe            AS CHARACTER INITIAL ?
     FIELD ChaveAcessoDCe   AS CHARACTER INITIAL ?
     FIELD VersaoLayoutDCe  AS CHARACTER INITIAL ?
     INDEX ch-ttDCe IS PRIMARY UNIQUE CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttIdeDCe NO-UNDO //Identifica‡Æo da Decla‡Æo de Conte£do eletr“nica
     FIELD cUF                AS CHARACTER INITIAL ?
     FIELD cDC                AS CHARACTER INITIAL ? //C¢digo Num‚rico que compäe a Chave de Acesso
     FIELD mod                AS CHARACTER INITIAL ? //C¢digo do Modelo da Declara‡Æo
     FIELD serie              AS CHARACTER INITIAL ?
     FIELD nDC                AS CHARACTER INITIAL ? //N£mero da Declara‡ao
     FIELD dhEmi              AS CHARACTER INITIAL ? //Data e hora de emissÆo da declara‡Æo
     FIELD tpEmis             AS CHARACTER INITIAL ? //Tipo de EmissÆo da DCe 1-normal 2-Contingˆncia
     FIELD tpEmit             AS CHARACTER INITIAL ? //Tipo do Emitente da DCe 0=Fisco 1=Marketplace 2=Emissor pr¢prio 3=Transportadora
     FIELD nSiteAutoriz       AS CHARACTER INITIAL ? //Site do Autorizador que recepcionou a DCe
     FIELD cDV                AS CHARACTER INITIAL ? //Dgito Verificador da Chave de Acesso da DCe
     FIELD tpAmb              AS CHARACTER INITIAL ? //Identifica‡Æo do Ambiente 1=Produ‡Æo 2=Homologa‡Æo
     FIELD verProc            AS CHARACTER INITIAL ? //VersÆo do Processo de emissÆo da DCe
     FIELD siteQRCode         AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     INDEX ch-ttIdeDCe IS PRIMARY UNIQUE CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttEmitDCe NO-UNDO //Identifica‡Æo do usu rio emitente da Declara‡Æo de Conte£do eletr“nica
     FIELD CNPJ               AS CHARACTER INITIAL ?
     FIELD CPF                AS CHARACTER INITIAL ?
     FIELD idOutros           AS CHARACTER INITIAL ? //Identifica‡Æo do emitente outros
     FIELD xNome              AS CHARACTER INITIAL ?
     FIELD xLgr               AS CHARACTER INITIAL ?
     FIELD nro                AS CHARACTER INITIAL ?
     FIELD xCpl               AS CHARACTER INITIAL ?
     FIELD xBairro            AS CHARACTER INITIAL ?
     FIELD cMun               AS CHARACTER INITIAL ?
     FIELD xMun               AS CHARACTER INITIAL ?
     FIELD UF                 AS CHARACTER INITIAL ?
     FIELD CEP                AS CHARACTER INITIAL ?
     FIELD cPais              AS CHARACTER INITIAL ?
     FIELD xPais              AS CHARACTER INITIAL ?
     FIELD fone               AS CHARACTER INITIAL ?
     FIELD email              AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     INDEX ch-ttEmitDCe IS PRIMARY UNIQUE CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttIDEmitDCe NO-UNDO //Identifica‡Æo da Empresa, Fisco, Marketplace ou Transportadora emitente da DC-e
     FIELD CNPJ               AS CHARACTER INITIAL ?
     FIELD xNome              AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     INDEX ch-ttIDEmitDCe IS PRIMARY UNIQUE CodEstabelDCe SerieDCe NrDCe.


DEFINE TEMP-TABLE ttDestDCe NO-UNDO //Identifica‡Æo do Destinat rio da Declara‡Æo eletr“nica
     FIELD CNPJ               AS CHARACTER INITIAL ?
     FIELD CPF                AS CHARACTER INITIAL ?
     FIELD idOutros           AS CHARACTER INITIAL ? //Identifica‡Æo do emitente outros
     FIELD xNome              AS CHARACTER INITIAL ?
     FIELD xLgr               AS CHARACTER INITIAL ?
     FIELD nro                AS CHARACTER INITIAL ?
     FIELD xCpl               AS CHARACTER INITIAL ?
     FIELD xBairro            AS CHARACTER INITIAL ?
     FIELD cMun               AS CHARACTER INITIAL ?
     FIELD xMun               AS CHARACTER INITIAL ?
     FIELD UF                 AS CHARACTER INITIAL ?
     FIELD CEP                AS CHARACTER INITIAL ?
     FIELD cPais              AS CHARACTER INITIAL ?
     FIELD xPais              AS CHARACTER INITIAL ?
     FIELD fone               AS CHARACTER INITIAL ?
     FIELD email              AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     INDEX ch-ttDestDCe IS PRIMARY UNIQUE CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttDetDCe NO-UNDO
     FIELD xProd              AS CHARACTER INITIAL ? //Descri‡Æo do produto, bem ou mercadoria
     FIELD NCM                AS CHARACTER INITIAL ? //Cap¡tulo do C¢digo NCM com 2 d¡gitos ou NCM completo
     FIELD qCom               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.99"    DECIMALS 4 //Quantidade
     FIELD vUnCom             AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 8 //Valor Unit rio
     FIELD vProd              AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2 //Valor Total Bruto do Produto
     FIELD infAdProd          AS CHARACTER INITIAL ? //Informa‡äes Adicionais do Produto
     /*Chave EMS*/            
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     FIELD NrSeqFatDCe        AS INTEGER   INITIAL ?
     FIELD ItCodigoDCe        AS CHARACTER INITIAL ?
     INDEX ch-ttDetDCe CodEstabelDCe SerieDCe NrDCe NrSeqFatDCe.

DEFINE TEMP-TABLE ttTransp NO-UNDO //Informa‡äes do Transporte da DCe
     FIELD modTrans           AS CHARACTER INITIAL ? //Modalidade do transporte  0=Transporte pelos correios 1=Transporte por contra pr¢pria 2=Transporte por empresa transportador
     FIELD CNPJTransp         AS CHARACTER INITIAL ? //CNPJ da Transportadora
     /*Chave EMS*/
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     INDEX ch-ttTransp CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttInfAdic NO-UNDO //Informa‡äes Adicionais da DCe
     FIELD infAdFisco         AS CHARACTER INITIAL ? //Informa‡äes Adicionais de Interesse do Fisco
     FIELD infCpl             AS CHARACTER INITIAL ? //Informa‡äes Complementares de interesse do usu rio emitente
     FIELD infAdTransp        AS CHARACTER INITIAL ? //Informa‡äes Adicionais da Transportadora
     /*Chave EMS*/
     FIELD CodEstabelDCe     AS CHARACTER INITIAL ?
     FIELD SerieDCe          AS CHARACTER INITIAL ?
     FIELD NrDCe             AS CHARACTER INITIAL ?
     INDEX ch-ttInfAdic CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttInfDec NO-UNDO //Declara‡Æo do usu rio emitente
     FIELD xObs1             AS CHARACTER INITIAL ? //Observa‡Æo 1 ao usu rio emitente
     FIELD xObs2             AS CHARACTER INITIAL ? //Observa‡Æo 2 ao usu rio emitente
     /*Chave EMS*/
     FIELD CodEstabelDCe     AS CHARACTER INITIAL ?
     FIELD SerieDCe          AS CHARACTER INITIAL ?
     FIELD NrDCe             AS CHARACTER INITIAL ?
     INDEX ch-ttInfDec CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttInfDCeSupl NO-UNDO //Informa‡äes Suplementares da DCe
     FIELD qrCode            AS CHARACTER INITIAL ? //Texto com o QR-Code impresso no DACE
     FIELD urlChave          AS CHARACTER INITIAL ? //URL para consulta da Chave de Acesso
     /*Chave EMS*/
     FIELD CodEstabelDCe     AS CHARACTER INITIAL ?
     FIELD SerieDCe          AS CHARACTER INITIAL ?
     FIELD NrDCe             AS CHARACTER INITIAL ?
     INDEX ch-ttInfDCeSupl CodEstabelDCe SerieDCe NrDCe.

DEFINE TEMP-TABLE ttTotalDCe NO-UNDO
     FIELD vDC                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 //Valor Total da DCe
     /*Chave EMS*/            
     FIELD CodEstabelDCe      AS CHARACTER INITIAL ?
     FIELD SerieDCe           AS CHARACTER INITIAL ?
     FIELD NrDCe              AS CHARACTER INITIAL ?
     INDEX ch-ttTotalDCe CodEstabelDCe SerieDCe NrDCe.


