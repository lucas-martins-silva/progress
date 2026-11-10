/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9020A 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9020a MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9020a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Detalhe da transacao de Ressuprimento WMS                                 **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-ressup-wms.cod-usuario      ~
                            tt-ressup-wms.cod-coletor      ~
                            tt-ressup-wms.cod-estabel      ~
                            tt-ressup-wms.cod-local        ~
                            tt-ressup-wms.des-endereco     ~
                            tt-ressup-wms.num-documento    ~
                            tt-ressup-wms.num-movimento    ~
                            tt-ressup-wms.num-seq-item     ~
                            tt-ressup-wms.num-box          ~
                            tt-ressup-wms.num-tempo-inicio ~
                            tt-ressup-wms.cod-equipamento  ~
                            tt-ressup-wms.cod-item         ~
                            tt-ressup-wms.qtd-item         ~
                            tt-ressup-wms.num-box-lido     ~
                            tt-ressup-wms.cod-embalagem    ~
                            tt-ressup-wms.qtd-embal-lidas  ~
                            tt-ressup-wms.des-seriais      ~
                            tt-ressup-wms.num-serial       ~
                            tt-ressup-wms.dat-atualizacao  ~
                            tt-ressup-wms.dat-transacao    

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9020.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramBC9020A
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9020
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-ressup-wms
/**********************  Table Preprocessor Definitions End  ********************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                          ' Usr: '  + String(tt-ressup-wms.cod-usuario)                     + ~
                          ' Col: '  + String(tt-ressup-wms.cod-coletor)                     + ~
                          ' Eqp: '  + String(tt-ressup-wms.cod-equipamento)                 + ~
                          ' Doc: '  + String(tt-ressup-wms.num-documento)                   + ~
                          ' Ser: '  + String(tt-ressup-wms.num-serial,'99999999999999')     + ~
                          ' Dat: '  + String(Today,'99/99/9999')                            + ~
                          ' Hor: '  + String(time,'hh:mm:ss')

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE CustomDisplayField01 
&GLOBAL-DEFINE CustomValueField01   
/**************  Fields Custom Display Preprocessor Definitions End  ************/
/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
&endif
