/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9028A 2.00.00.002} /*** "010002" 21/03/2024 11:40:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9028a MBC}
&ENDIF



/********************************************************************************************
**   Programa..: bc9029a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Abril/2005 - Paulo Eduardo Budal                            **
**                                                                                         **
**   Objetivo..: Manuten»’o - montagem de pallet wms                                       **
**                                                                                         **
**   Includes..: bcp/bc9127.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields     tt-reporte-serial-wms.cod-usuario        ~
                               tt-reporte-serial-wms.cod-coletor        ~
                               tt-reporte-serial-wms.cod-equipamento    ~
                               tt-reporte-serial-wms.cod-estabel        ~
                               tt-reporte-serial-wms.cod-depos          ~
                               tt-reporte-serial-wms.num-serial         ~
                               tt-reporte-serial-wms.op-codigo          ~
                               tt-reporte-serial-wms.pto-controle
                                  



/********************  Frame Fields Preprocessor Definitions End  ***************/
/*****************  Name of TT Include Preprocessor Definitions Beg  ************/

&GLOBAL-DEFINE NameOfTTInclude bcp/bc9028.i

/*****************  Name of TT Include Preprocessor Definitions End  ************/
/*******************  Program Title Preprocessor Definitions Beg  ***************/

&GLOBAL-DEFINE ProgramBC9028A

/*******************  Program Title Preprocessor Definitions End  ***************/
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2

/**************  Frame Number of Columns Preprocessor Definitions End  **********/
/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/

&GLOBAL-DEFINE TransactionProgram bc9028

/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-reporte-serial-wms

/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                          "Serial: "       +  STRING({&Table}.num-serial)     + ~
                          "Estab: "        +  STRING({&Table}.cod-estabel)    + ~
                          "Depos: "        +  STRING({&Table}.cod-depos)      + ~
                          "Pto Controle: " + STRING({&Table}.pto-controle)
                          
                          
/**********************  Table Preprocessor Definitions End  ********************/

/**************  Fields Custom Display Preprocessor Definitions Beg  ************/

/*&GLOBAL-DEFINE CustomDisplayField01 tt-transfere-bc.data-transacao
&GLOBAL-DEFINE CustomValueField01   String(today,'99/99/9999')*/

/**************  Fields Custom Display Preprocessor Definitions End  ************/
/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/
/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}



