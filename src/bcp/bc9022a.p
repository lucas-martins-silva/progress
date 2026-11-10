/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9022A 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9022a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9022a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Detalhe da transacao de Ressuprimento WMS                                 **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-packing-wms.cod-usuario      ~
                            tt-packing-wms.cod-coletor      ~
                            tt-packing-wms.cod-equipamento  ~
                            tt-packing-wms.cod-estabel      ~
                            tt-packing-wms.cod-local        ~
                            tt-packing-wms.cod-pedcli       ~
                            tt-packing-wms.nom-abrev        ~
                            tt-packing-wms.num-documento    ~
                            tt-packing-wms.cdd-embarq       ~
                            tt-packing-wms.num-resumo       ~
                            tt-packing-wms.num-tarefa       ~
                            tt-packing-wms.cod-volume       ~
                            tt-packing-wms.num-volume-pack  ~
                            tt-packing-wms.num-seq-volume   ~
                            tt-packing-wms.num-serial       ~
                            tt-packing-wms.cod-item         ~
                            tt-packing-wms.des-item         ~
                            tt-packing-wms.qtd-item         ~
                            tt-packing-wms.qtd-peso         ~
                            tt-packing-wms.dat-transacao    ~
                            tt-packing-wms.log-finaliza     ~
                            tt-packing-wms.log-inicializa   ~
                            tt-packing-wms.tip-movimento

/********************  Frame Fields Preprocessor Definitions End  ***************/

/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9022.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/

/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramBC9022A
/*******************  Program Title Preprocessor Definitions End  ***************/

/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/

/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9022
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-packing-wms
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail ' Usr: '  + String(tt-packing-wms.cod-usuario)                    + ~
                           ' Col: '  + String(tt-packing-wms.cod-coletor)                    + ~
                           ' Equ: '  + String(tt-packing-wms.cod-equipamento)                + ~
                           ' Doc: '  + String(tt-packing-wms.num-documento)                  + ~
                           ' Vol: '  + String(tt-packing-wms.num-volume-pack)                + ~
                           ' Ser: '  + String(tt-packing-wms.num-serial,'99999999999999')

/**********************  Table Preprocessor Definitions End  ********************/

/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE CustomDisplayField01 
&GLOBAL-DEFINE CustomValueField01   
/**************  Fields Custom Display Preprocessor Definitions End  ************/
/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
