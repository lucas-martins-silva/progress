/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9010A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9010a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9010a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jan/2001 - Denis Roberto Eloterio                           **
**                                                                                         **
**   Objetivo..: Teste para o programa de altera‡Æo Movto Saida WMS (bcp/bc9010.p)         **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/


/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-box-movto-bc.cod-estabel-ped ~
                            tt-box-movto-bc.cod-estabel-col ~
                            tt-box-movto-bc.id-box-ped ~
                            tt-box-movto-bc.id-box-col ~
                            tt-box-movto-bc.id-docto-ped ~
                            tt-box-movto-bc.id-docto-col ~
                            tt-box-movto-bc.cod-local-ped ~
                            tt-box-movto-bc.cod-local-col ~
                            tt-box-movto-bc.num-seq-item-ped ~
                            tt-box-movto-bc.num-seq-item-col ~
                            tt-box-movto-bc.qtd-item-ped ~
                            tt-box-movto-bc.qtd-item-col ~
                            tt-box-movto-bc.qti-embalagem-ped ~
                            tt-box-movto-bc.qti-embalagem-col ~
                            tt-box-movto-bc.cod-item-ped ~
                            tt-box-movto-bc.cod-item-col ~
                            tt-box-movto-bc.cod-embalagem-ped ~
                            tt-box-movto-bc.cod-embalagem-col ~
                            tt-box-movto-bc.dt-transacao-ped ~
                            tt-box-movto-bc.dt-transacao-col ~
                            tt-box-movto-bc.ind-origem-docto ~
                            tt-box-movto-bc.data-transacao-ini ~
                            tt-box-movto-bc.hora-transacao-ini ~
                            tt-box-movto-bc.data-transacao-fim ~
                            tt-box-movto-bc.hora-transacao-fim ~
                            tt-box-movto-bc.usuario
                            
/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9010.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramBC9010A
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9010
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-box-movto-bc
/**********************  Table Preprocessor Definitions End  ********************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction +  ~
                          ' Est: '      + String(tt-box-movto-bc.cod-estabel-col) + ~
                          ' Loc: '      + Trim(tt-box-movto-bc.cod-local-col)     + ~
                          ' Doc: '      + string(tt-box-movto-bc.id-docto-col)    + ~
                          ' It: '       + Trim(tt-box-movto-bc.cod-item-col)      + ~
                          ' Box: '      + String(tt-box-movto-bc.id-box-col)      + ~
                          ' Qti: '      + String(tt-box-movto-bc.qtd-item-col)    + ~
                          ' Emb: '      + Trim(tt-box-movto-bc.cod-embalagem-col)


/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE CustomDisplayField01 
&GLOBAL-DEFINE CustomValueField01   
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
