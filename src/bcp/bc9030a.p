/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9030A 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9030a MBC}
&ENDIF


{include/i_dbvers.i}  /* versao das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then

/********************************************************************************************
**   Programa..: bc9030a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Abril/2005 - Marcelo Dumke                            **
**                                                                                         **
**   Objetivo..: Manuten»’o - montagem de pallet wms                                       **
**                                                                                         **
**   Includes..: bcp/bc9127.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields     tt-transfer-serial-wms.cod-usuario        ~
                               tt-transfer-serial-wms.cod-coletor        ~
                               tt-transfer-serial-wms.cod-equipamento    ~
                               tt-transfer-serial-wms.cod-serial         ~
                               tt-transfer-serial-wms.cod-depos-orig     ~
                               tt-transfer-serial-wms.cod-local-orig     ~
                               tt-transfer-serial-wms.cod-depos-dest     ~
                               tt-transfer-serial-wms.cod-local-dest     ~
                               tt-transfer-serial-wms.tipo-equipamento   ~
                               tt-transfer-serial-wms.cod-item           ~
                               tt-transfer-serial-wms.qtd-item           ~
                               tt-transfer-serial-wms.data-atualizacao   ~
                               tt-transfer-serial-wms.data-transacao     ~
                               tt-transfer-serial-wms.cod-lote           ~
                               tt-transfer-serial-wms.num-docto-transf   ~
                               tt-transfer-serial-wms.cod-estabel    


/********************  Frame Fields Preprocessor Definitions End  ***************/
/*****************  Name of TT Include Preprocessor Definitions Beg  ************/

&GLOBAL-DEFINE NameOfTTInclude bcp/bc9030.i

/*****************  Name of TT Include Preprocessor Definitions End  ************/
/*******************  Program Title Preprocessor Definitions Beg  ***************/

&GLOBAL-DEFINE ProgramBC9030A

/*******************  Program Title Preprocessor Definitions End  ***************/
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2

/**************  Frame Number of Columns Preprocessor Definitions End  **********/
/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/

&GLOBAL-DEFINE TransactionProgram bc9030

/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-transfer-serial-wms

/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail " SERIAL: " + string(tt-transfer-serial-wms.cod-serial) + ~
                           " IT: "     + tt-transfer-serial-wms.cod-item + ~
                           " QTD: "    + STRING(tt-transfer-serial-wms.qtd-item)


/**********************  Table Preprocessor Definitions End  ********************/

/**************  Fields Custom Display Preprocessor Definitions Beg  ************/

/*&GLOBAL-DEFINE CustomDisplayField01 tt-transfere-bc.data-transacao
&GLOBAL-DEFINE CustomValueField01   String(today,'99/99/9999')*/

/**************  Fields Custom Display Preprocessor Definitions End  ************/
/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/
/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}

&else 

    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif


