unit UntDecl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, ADODB, StdCtrls, Grids, DBGrids, ComCtrls,
  Buttons, MPlayer, Gauges;

type
  TFrmDecl_Imp = class(TForm)
    Db: TADOConnection;
    QrDecl_Import: TADOQuery;
    QrDecl_ImportNR_DECL_IMP_MICRO: TWideStringField;
    QrDecl_ImportNR_IDENT_USUARIO: TWideStringField;
    QrDecl_ImportNR_DECL_IMP_PROT: TWideStringField;
    QrDecl_ImportNR_DECLARACAO_IMP: TWideStringField;
    QrDecl_ImportDT_PROCESSAMENTO: TWideStringField;
    QrDecl_ImportDT_TRANSMISSAO: TWideStringField;
    QrDecl_ImportDT_REGISTRO_DI: TWideStringField;
    QrDecl_ImportCD_TIPO_DECLARACAO: TWideStringField;
    QrDecl_ImportCD_MOTIVO_TRANS: TWideStringField;
    QrDecl_ImportCD_TIPO_IMPORTADOR: TWideStringField;
    QrDecl_ImportNR_IMPORTADOR: TWideStringField;
    QrDecl_ImportCD_PAIS_IMPORTADOR: TWideStringField;
    QrDecl_ImportNM_IMPORTADOR: TWideStringField;
    QrDecl_ImportNR_TEL_IMPORTADOR: TWideStringField;
    QrDecl_ImportED_LOGR_IMPORTADOR: TWideStringField;
    QrDecl_ImportED_NR_IMPORTADOR: TWideStringField;
    QrDecl_ImportED_COMPL_IMPO: TWideStringField;
    QrDecl_ImportED_BA_IMPORTADOR: TWideStringField;
    QrDecl_ImportED_MUN_IMPORTADOR: TWideStringField;
    QrDecl_ImportED_UF_IMPORTADOR: TWideStringField;
    QrDecl_ImportED_CEP_IMPORTADOR: TWideStringField;
    QrDecl_ImportNR_CPF_REPR_LEGAL: TWideStringField;
    QrDecl_ImportCD_MODALIDADE_DESP: TWideStringField;
    QrDecl_ImportIN_OPERACAO_FUNDAP: TBooleanField;
    QrDecl_ImportCD_URF_ENTR_CARGA: TWideStringField;
    QrDecl_ImportCD_URF_DESPACHO: TWideStringField;
    QrDecl_ImportCD_TIPO_CONSIG: TWideStringField;
    QrDecl_ImportNR_CONSIGNATARIO: TWideStringField;
    QrDecl_ImportNM_CONSIGNATARIO: TWideStringField;
    QrDecl_ImportCD_PAIS_PROC_CARGA: TWideStringField;
    QrDecl_ImportCD_VIA_TRANSP_CARG: TWideStringField;
    QrDecl_ImportIN_MULTIMODAL: TBooleanField;
    QrDecl_ImportNR_VEICULO_TRANSP: TWideStringField;
    QrDecl_ImportNM_VEICULO_TRANSP: TWideStringField;
    QrDecl_ImportNM_TRANSPORTADOR: TWideStringField;
    QrDecl_ImportCD_BANDEIRA_TRANSP: TWideStringField;
    QrDecl_ImportCD_TIPO_AG_CARGA: TWideStringField;
    QrDecl_ImportNR_AGENTE_CARGA: TWideStringField;
    QrDecl_ImportCD_TIPO_DCTO_CARGA: TWideStringField;
    QrDecl_ImportNR_DCTO_CARGA: TWideStringField;
    QrDecl_ImportNR_DCTO_CARGA_MAST: TWideStringField;
    QrDecl_ImportNM_LOCAL_EMBARQUE: TWideStringField;
    QrDecl_ImportDT_EMBARQUE: TWideStringField;
    QrDecl_ImportCD_UTIL_DCTO_CARGA: TWideStringField;
    QrDecl_ImportPB_CARGA: TWideStringField;
    QrDecl_ImportPL_CARGA: TWideStringField;
    QrDecl_ImportDT_CHEGADA_CARGA: TWideStringField;
    QrDecl_ImportCD_TIPO_MANIFESTO: TWideStringField;
    QrDecl_ImportNR_MANIFESTO: TWideStringField;
    QrDecl_ImportCD_RECINTO_ALFAND: TWideStringField;
    QrDecl_ImportCD_SETOR_ARMAZENAM: TWideStringField;
    QrDecl_ImportCD_MOEDA_FRETE: TWideStringField;
    QrDecl_ImportVL_TOT_FRT_PREPAID: TFloatField;
    QrDecl_ImportVL_TOT_FRT_COLLECT: TFloatField;
    QrDecl_ImportVL_FRETE_TNAC_MNEG: TFloatField;
    QrDecl_ImportVL_TOTAL_FRETE_MN: TFloatField;
    QrDecl_ImportCD_MOEDA_SEGURO: TWideStringField;
    QrDecl_ImportVL_TOT_SEGURO_MNEG: TFloatField;
    QrDecl_ImportVL_TOTAL_SEG_MN: TFloatField;
    QrDecl_ImportCD_MOEDA_DESPESAS: TWideStringField;
    QrDecl_ImportVL_TOT_DESPS_MNEG: TFloatField;
    QrDecl_ImportVL_TOT_DESPS_MN: TFloatField;
    QrDecl_ImportCD_MOEDA_MLE: TWideStringField;
    QrDecl_ImportVL_TOT_MLE_MNEG: TFloatField;
    QrDecl_ImportVL_TOTAL_MLE_MN: TFloatField;
    QrDecl_ImportIN_MOEDA_UNICA: TBooleanField;
    QrDecl_ImportTX_INFO_COMPL: TMemoField;
    QrDecl_ImportCD_TIPO_PGTO_TRIB: TWideStringField;
    QrDecl_ImportNR_CONTA_PGTO_TRIB: TWideStringField;
    LblAgua: TLabel;
    LblStat: TLabel;
    QrAdicao: TADOQuery;
    QrAdicaoNR_DECL_IMP_MICRO: TWideStringField;
    QrAdicaoNR_OP_IMP_MICRO: TWideStringField;
    QrAdicaoCD_URF_ENTR_MERC: TWideStringField;
    QrAdicaoCD_VIA_TRANSPORTE: TWideStringField;
    QrAdicaoIN_MULTIMODAL: TBooleanField;
    QrAdicaoNM_FORN_ESTR: TWideStringField;
    QrAdicaoED_LOGR_FORN_ESTR: TWideStringField;
    QrAdicaoED_NR_FORN_ESTR: TWideStringField;
    QrAdicaoED_COMPL_FORN_ESTR: TWideStringField;
    QrAdicaoED_CIDAD_FORN_ESTR: TWideStringField;
    QrAdicaoED_ESTAD_FORN_ESTR: TWideStringField;
    QrAdicaoCD_PAIS_AQUIS_MERC: TWideStringField;
    QrAdicaoCD_MERCADORIA_NCM: TWideStringField;
    QrAdicaoCD_PAIS_PROC_MERC: TWideStringField;
    QrAdicaoCD_AUSENCIA_FABRIC: TWideStringField;
    QrAdicaoNM_FABRICANTE_MERC: TWideStringField;
    QrAdicaoED_LOGR_FABRIC: TWideStringField;
    QrAdicaoED_NR_FABRIC: TWideStringField;
    QrAdicaoED_COMPL_FABRIC: TWideStringField;
    QrAdicaoED_CIDAD_FABRIC: TWideStringField;
    QrAdicaoED_ESTADO_FABRIC: TWideStringField;
    QrAdicaoCD_PAIS_ORIG_MERC: TWideStringField;
    QrAdicaoCD_MERC_NBM_SH: TWideStringField;
    QrAdicaoCD_MERC_NALADI_NCC: TWideStringField;
    QrAdicaoCD_MERC_NALADI_SH: TWideStringField;
    QrAdicaoPL_MERCADORIA: TWideStringField;
    QrAdicaoQT_UN_ESTATISTICA: TWideStringField;
    QrAdicaoCD_APLICACAO_MERC: TWideStringField;
    QrAdicaoVL_MERC_EMB_MN: TFloatField;
    QrAdicaoCD_MOEDA_NEGOCIADA: TWideStringField;
    QrAdicaoCD_INCOTERMS_VENDA: TWideStringField;
    QrAdicaoNM_LOC_COND_VENDA: TWideStringField;
    QrAdicaoVL_MERC_COND_VENDA: TFloatField;
    QrAdicaoVL_MERC_VENDA_MN: TFloatField;
    QrAdicaoVL_FRETE_MERC_MNEG: TFloatField;
    QrAdicaoCD_MD_FRETE_MERC: TWideStringField;
    QrAdicaoVL_FRETE_MERC_MN: TFloatField;
    QrAdicaoVL_SEG_MERC_MNEG: TFloatField;
    QrAdicaoCD_MOEDA_SEG_MERC: TWideStringField;
    QrAdicaoVL_SEG_MERC_MN: TFloatField;
    QrAdicaoVL_UNID_LOC_EMP: TFloatField;
    QrAdicaoCD_METOD_VALORACAO: TWideStringField;
    QrAdicaoCD_VINC_IMPO_EXPO: TWideStringField;
    QrAdicaoCD_TIPO_ACORDO_TAR: TWideStringField;
    QrAdicaoCD_ACORDO_ALADI: TWideStringField;
    QrAdicaoCD_REGIME_TRIBUTAR: TWideStringField;
    QrAdicaoCD_FUND_LEG_REGIME: TWideStringField;
    QrAdicaoCD_MOTIVO_ADM_TEMP: TWideStringField;
    QrAdicaoNR_DCTO_REDUCAO: TWideStringField;
    QrAdicaoVL_DESPESAS_MNEG: TFloatField;
    QrAdicaoCD_MOEDAS_DESPESAS: TWideStringField;
    QrAdicaoVL_DESPESAS_MN: TFloatField;
    QrAdicaoPC_COEF_REDUC_II: TFloatField;
    QrAdicaoVL_CALC_DCR_DOLAR: TFloatField;
    QrAdicaoVL_II_CALC_DCR_MN: TFloatField;
    QrAdicaoVL_II_DEVIDO_ZFM: TFloatField;
    QrAdicaoVL_II_A_REC_ZFM: TFloatField;
    QrAdicaoCD_COBERT_CAMBIAL: TWideStringField;
    QrAdicaoCD_MODALIDADE_PGTO: TWideStringField;
    QrAdicaoCD_ORGAO_FIN_INTER: TWideStringField;
    QrAdicaoCD_MOTIVO_SEM_COB: TWideStringField;
    QrAdicaoQT_PARC_FINANC_360: TWideStringField;
    QrAdicaoCD_PERIOD_PGTO_360: TWideStringField;
    QrAdicaoQT_PERIOD_PGTO_360: TWideStringField;
    QrAdicaoVL_TOT_FINANC_360: TFloatField;
    QrAdicaoPC_TAXA_JUROS: TFloatField;
    QrAdicaoCD_TAXA_JUROS: TWideStringField;
    QrAdicaoVL_FINANC_SUP_360: TFloatField;
    QrAdicaoNR_ROF: TWideStringField;
    QrAdicaoIN_PGTO_VARIAV_360: TBooleanField;
    QrAdicaoIN_JUROS_ATE_360: TBooleanField;
    QrAdicaoPC_COMISSAO_AG_IMP: TFloatField;
    QrAdicaoVL_COMISSAO_AG_IMP: TFloatField;
    QrAdicaoCD_TIPO_AGENTE_IMP: TWideStringField;
    QrAdicaoNR_AGENTE_IMP: TWideStringField;
    QrAdicaoCD_BANC_AGENTE_IMP: TWideStringField;
    QrAdicaoCD_AGENC_AGENT_IMP: TWideStringField;
    QrAdicaoIN_BEM_ENCOMENDA: TBooleanField;
    QrAdicaoIN_MATERIAL_USADO: TBooleanField;
    QrAdicaoTX_COMPL_VL_ADUAN: TWideStringField;
    QrAdicaoIN_IPI_NAO_TRIBUT: TBooleanField;
    QrAdicaovl_merc_loc_emb_mn: TFloatField;
    QrAdicaovl_base_calculo_mn: TFloatField;
    QrAdicaoNR_OPER_TRAT_PREV: TWideStringField;
    QrParcelas: TADOQuery;
    QrParcelasNR_DECL_IMP_MICRO: TWideStringField;
    QrParcelasNR_OP_IMP_MICRO: TWideStringField;
    QrParcelasNU_SEQ_PAG_PREV: TWordField;
    QrParcelasDT_PREV_PGTO_360: TWideStringField;
    QrParcelasVL_PREV_PGTO_360: TFloatField;
    QrTributos: TADOQuery;
    QrDetMercad: TADOQuery;
    Progress: TGauge;
    QrTributosNR_DECL_IMP_MICRO: TWideStringField;
    QrTributosNR_OP_IMP_MICRO: TWideStringField;
    QrTributosCD_RECEITA_IMPOSTO: TWideStringField;
    QrTributosCD_TIPO_ALIQ_IPT: TWideStringField;
    QrTributosVL_BASE_CALC_ADVAL: TFloatField;
    QrTributosPC_ALIQ_NORM_ADVAL: TFloatField;
    QrTributosVL_CALC_IPT_ADVAL: TFloatField;
    QrTributosNM_UN_ALIQ_ESP_IPT: TWideStringField;
    QrTributosCD_TIPO_RECIPIENTE: TWideStringField;
    QrTributosQT_ML_RECIPIENTE: TFloatField;
    QrTributosQT_MERC_UN_ALIQ_ES: TFloatField;
    QrTributosVL_ALIQ_ESPEC_IPT: TFloatField;
    QrTributosVL_CALC_IPT_ESPEC: TFloatField;
    QrTributosCD_TIPO_BENEF_IPI: TWideStringField;
    QrTributosPC_ALIQ_REDUZIDA: TFloatField;
    QrTributosPC_REDUCAO_IPT_BLI: TFloatField;
    QrTributosPC_ALIQ_ACOR_TARIF: TFloatField;
    QrTributosVL_CALC_II_AC_TARI: TFloatField;
    QrTributosVL_IMPOSTO_DEVIDO: TFloatField;
    QrTributosVL_IPT_A_RECOLHER: TFloatField;
    QrTributosCD_TIPO_DIREITO: TWideStringField;
    QrTributosNR_NOTA_COMPL_TIPI: TWideStringField;
    QrDetMercadNR_DECL_IMP_MICRO: TWideStringField;
    QrDetMercadNR_OP_IMP_MICRO: TWideStringField;
    QrDetMercadNU_SEQ_DETALHE: TWordField;
    QrDetMercadTX_DESC_DET_MERC: TMemoField;
    QrDetMercadQT_MERC_UN_COMERC: TWideStringField;
    QrDetMercadNM_UN_MEDID_COMERC: TWideStringField;
    QrDetMercadVL_UNID_LOC_EMB: TFloatField;
    QrDetMercadVL_UNID_COND_VENDA: TWideStringField;
    QrDetMercadCD_PRODUTO: TWideStringField;
    procedure FormShow(Sender: TObject);
  private
    arq,bd: string; // Variaveis com o caminho do arquivo e caminbho do bd
    error,headerror: Pchar;
    txt: TextFile;
    function VerifParametros(var Error, HeadError: Pchar): boolean;
    procedure InsertRegCabecalho;
    procedure InsertRegAdicao;
    procedure InsertRegParcelas;
    procedure InsertRegTributos;
    procedure InsertRegDetalhesMercad;
    procedure InsertRegDetalhesMerc;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDecl_Imp: TFrmDecl_Imp;
  i:integer;
  linha_header,c1:string;
  nd : string; // nº da declaraçao
  na : integer; // nº da adiçao
  np : integer; // nº da parcela
  nm : integer; // nº do detalhe da mercadoria
  msg : string; //mensagem padrão de erro.

  MercadNR_DECL_IMP_MICRO: string;
  MercadNR_OP_IMP_MICRO: string;
  MercadCD_PRODUTO: string;
  MercadNM_UN_MEDID_COMERC: string;
  MercadNU_SEQ_DETALHE : integer;
  MercadVL_UNID_LOC_EMB : Double;
  MercadVL_UNID_COND_VENDA : String;


implementation

{$R *.dfm}

function TFrmDecl_Imp.VerifParametros(var Error,
  HeadError: Pchar): boolean;
const
id = 0; // Constante e Variaveis que conterão as informaçoes
         // do arquivo para analisar a estrutura
var
data,hora: integer;
begin
  Result := False;
  msg := 'Erro ao importar o Campo: ';
  arq := ParamStr(1);
  //arq := 'c:/tmp/samuel/05012009_05012009.txt';
  AssignFile(txt,arq);
  // Verifica se o arquivo existe.
  if not (FileExists(arq)) then
   begin
     Error := 'Arquivo para importação nao existente!';
     HeadError := 'Arquivo não encontrado';
     Exit;
   end;
  // Verifica se o caminho do bd esta correto
  try
   Db.Connected := false;
   Db.ConnectionString := ParamStr(2);
   //Db.ConnectionString := 'C:\SISCODEM\import.dem\IMPORT.MDB';
   Progress.Progress := 0;
   Db.Connected := true;
  except
    on E: Exception do
      begin
        Error := 'Não foi possivel estabelecer a conexão com o banco de dados!' + #13 +
                   'Verifique o caminho do banco de dados informado.';
        HeadError := 'Conexão não foi estabelecida';
        Exit;
      end;
  end;
  // Verifica se o arquivo informado possui o layout do
  // arquivo de declaração através do "REGISTRO HEADER DO ARQUIVO"
  try
   Reset(txt);
   i:= 1;
   While not Eoln(txt) do
    begin
       Readln(txt);
       inc(i);
    end;
   CloseFile(txt);
   Reset(txt);
   Readln(txt,linha_header);
   if id = strtoint(copy(linha_header,1,1)) then
    begin
      data := strtoint(copy(linha_header,88,8));
      hora := strtoint(copy(linha_header,100,6));
    end;
  except
    on E: Exception do
      begin
        Error := 'Lay-Out do arquivo é inválido!' + #13 +
                 'Verifique o arquivo informado.';
        HeadError := 'Arquivo inválido';
        Exit;
      end;
  end;
  // Se chegou até aqui, parâmetros são corretos, podendo dar-se
  // inicio a importação dos registros nas tabelas
  Progress.MaxValue := i;
  Result := True;
  //-------------#Fim do Passo 1#--------------
end;

procedure TFrmDecl_Imp.FormShow(Sender: TObject);
var
mens : string;
begin

  //Passo 1: Verificação da existencia dos parametros.
  if ParamCount < 2 then
   begin
     MessageBox(0,'Parâmetros não informados!' +#13+
                'Informe o caminho do arquivo e o caminho da base de dados...','Erro...',0+48);
     Application.Terminate;
   end
 else
   if not VerifParametros(Error,HeadError) then
    begin
      MessageBox(0,(Error),(HeadError),0+48);
      Application.Terminate;
    end;

  i  := 0;
  na := 0;
  np := 0;
  nm := 0;
  LblStat.Caption := 'Iniciando leitura do arquivo...';
  Progress.Progress := Progress.Progress + 1;
  Db.BeginTrans;

  While not Eoln(txt) do
   begin

    Application.ProcessMessages;
    inc(i);
    Readln(txt,linha_header);
    c1:= copy(linha_header,1,1);

    if (c1 = '1') and (i = 1) then InsertRegCabecalho else
    if c1 = '2' then
     begin
      na := na + 1;
      nm := -1;
      if Length(inttostr(na)) = 1 then na := 00 + na;
      if Length(inttostr(na)) = 2 then na := 0  + na;
       InsertRegAdicao;
     end else
    if (c1 = '3') and (i >= 2) then
     begin
      np := np + 1;
      if Length(inttostr(np)) = 1 then np := 00 + np;
      if Length(inttostr(np)) = 2 then np := 0  + np;
       InsertRegParcelas;
     end else
    if (c1 = '4') and (i >= 2) then InsertRegTributos else
    if (c1 = '5') and (i >= 2) then
      begin
        nm := nm + 1;
        InsertRegDetalhesMercad;
     end
    else
    if (c1 = '6') and (i >= 2) then InsertRegDetalhesMerc else
      begin
         mens := Pchar('Falha na leitura do arquivo na linha ' + inttostr(i+1)+ '!' +#13+
                       'Verifique o arquivo e tente novamente.');
         MessageBox(0, Pchar(mens),'Arquivo corrompido!', MB_OK+MB_ICONERROR+MB_SETFOREGROUND);

         Application.Terminate;
      end;




   end;

   Progress.Progress := Progress.Progress + 1;
   LblAgua.Visible := false;
   LblStat.Caption := 'Importação concluída...';

   //Se chegou ate aqui, realizou a importação com sucesso...
   CloseFile(txt);
   Db.CommitTrans;
   Db.Connected := false;
   MessageBox(0,'Importação efetuada com sucesso!','Informação', 0+48);
   Application.Terminate;
end;

procedure TFrmDecl_Imp.InsertRegAdicao;
var
cpf,cnpj : string;
begin
  try
    with QrAdicao do
     begin
       if not Active then
        Active := True;

       cpf := '';
       cnpj:= '';
       LblStat.Caption := 'Importando registro nº '+ inttostr(i) +'...';
       Progress.Progress := Progress.Progress + 1;
          //Inicio da inclusao dos campos;
          QrAdicao.Append;
       // chaves primárias - tratamento especial
       try
          QrAdicaoNR_DECL_IMP_MICRO.AsString := nd; // Recebe o nº atual da declaração
       except
          MessageDlg(msg + 'NR_DECL_IMP_MICRO',mtError, mbOKCancel, -1);
       end;
       try
          //QrAdicaoNR_OP_IMP_MICRO.AsString := inttostr(na); Recebe o nº atual da adição ---samuel---
          QrAdicaoNR_OP_IMP_MICRO.AsString := copy(linha_header,17,3);
       except
          MessageDlg(msg + 'NR_OP_IMP_MICRO',mtError, mbOKCancel, -1);
       end;
       // fim chaves primárias
       try
          QrAdicaoCD_AUSENCIA_FABRIC.AsString := copy(linha_header,20,1);
       except
          MessageDlg(msg + 'CD_AUSENCIA_FABRIC',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoNM_FORN_ESTR.AsString := copy(linha_header,21,60);
       except
          MessageDlg(msg + 'NM_FORN_ESTR',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoED_LOGR_FORN_ESTR.AsString := copy(linha_header,81,40);
       except
          MessageDlg(msg + 'ED_LOGR_FORN_ESTR',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoED_CIDAD_FORN_ESTR.AsString := copy(linha_header,121,25);
       except
          MessageDlg(msg + 'ED_CIDAD_FORN_ESTR',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoED_ESTAD_FORN_ESTR.AsString := copy(linha_header,146,25);
       except
          MessageDlg(msg + 'ED_ESTAD_FORN_ESTR',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoNM_FABRICANTE_MERC.AsString := copy(linha_header,171,60);
       except
          MessageDlg(msg + 'NM_FABRICANTE_MERC',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoED_LOGR_FABRIC.AsString := copy(linha_header,231,40);
       except
          MessageDlg(msg + 'ED_LOGR_FABRIC',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoED_CIDAD_FABRIC.AsString := copy(linha_header,271,25);
       except
          MessageDlg(msg + 'ED_CIDAD_FABRIC',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoED_ESTADO_FABRIC.AsString := copy(linha_header,296,25);
       except
          MessageDlg(msg + 'ED_ESTADO_FABRIC',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_MERCADORIA_NCM.AsString := copy(linha_header,321,8);
       except
          MessageDlg(msg + 'CD_MERCADORIA_NCM',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_MERC_NBM_SH.AsString := copy(linha_header,329,10);
       except
          MessageDlg(msg + 'CD_MERC_NBM_SH',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_MERC_NALADI_SH.AsString := copy(linha_header,339,8);
       except
          MessageDlg(msg + 'CD_MERC_NALADI_SH',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_MERC_NALADI_NCC.AsString := copy(linha_header,347,7);
       except
          MessageDlg(msg + 'CD_MERC_NALADI_NCC',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoQT_UN_ESTATISTICA.AsString := copy(linha_header,354,14);
       except
          MessageDlg(msg + 'QT_UN_ESTATISTICA',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoPL_MERCADORIA.AsString := copy(linha_header,368,15);
       except
          MessageDlg(msg + 'PL_MERCADORIA',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_MOEDA_NEGOCIADA.AsString := copy(linha_header,383,3);
       except
          MessageDlg(msg + 'CD_MOEDA_NEGOCIADAO',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_INCOTERMS_VENDA.AsString := copy(linha_header,386,3);
       except
          MessageDlg(msg + 'CD_INCOTERMS_VENDA',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoNM_LOC_COND_VENDA.AsString := copy(linha_header,389,60);
       except
          MessageDlg(msg + 'NM_LOC_COND_VENDA',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_TIPO_AGENTE_IMP.AsString := copy(linha_header,449,1);
       except
          MessageDlg(msg + 'CD_TIPO_AGENTE_IMP',mtError, mbOKCancel, -1);
       end;

       if QrAdicaoCD_Tipo_AGENTE_IMP.AsString = '2' then
         begin
           cpf := copy(linha_header,450,11);
           QrAdicaoNR_AGENTE_IMP.AsString := cpf;
         end
       else
         begin
           cnpj := copy(linha_header,450,14);
           QrAdicaoNR_AGENTE_IMP.AsString := cnpj;
         end;
       
       try
          QrAdicaoCD_BANC_AGENTE_IMP.AsString := copy(linha_header,464,5);
       except
          MessageDlg(msg + 'CD_BANC_AGENTE_IMP',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoCD_AGENC_AGENT_IMP.AsString := copy(linha_header,469,4);
       except
          MessageDlg(msg + 'CD_AGENC_AGENT_IMP',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoQT_PARC_FINANC_360.AsString := copy(linha_header,473,3);
       except
          MessageDlg(msg + 'QT_PARC_FINANC_360',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoQT_PERIOD_PGTO_360.AsString := copy(linha_header,476,3);
       except
          MessageDlg(msg + 'QT_PERIOD_PGTO_360',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoVL_TOT_FINANC_360.AsFloat := (strtofloat(copy(linha_header,479,15)) / (100));
       except
          MessageDlg(msg + 'VL_TOT_FINANC_360',mtError, mbOKCancel, -1);
       end;
       try
          QrAdicaoNR_ROF.AsString :=copy(linha_header,494,8);
       except
          MessageDlg(msg + 'NR_ROF',mtError, mbOKCancel, -1);
       end;
       QrAdicao.Post;
       // Fim da inclusao dos campos
     end;
  except
    Db.RollbackTrans;
    Db.Connected := false;
    MessageBox(0,'1 - Geração da "DI" não foi concluída.' + #13 + 'Verifique o Banco de dados e tente novamente.', 'Alerta!', 0+48);
    Application.Terminate;
  end;
end;

procedure TFrmDecl_Imp.InsertRegCabecalho;
var
data: string;
ano,mes,dia : Word;
begin
  try
    with QrDecl_Import do
     begin
       if not Active then
        Active := true;

       LblStat.Caption := 'Importando registro nº '+ inttostr(i) +'...';
       Progress.Progress := Progress.Progress + 1;
       // Chave primária - tratamento especial
       nd := inttostr(QrDecl_Import.RecordCount + 1);

       if Length(nd) = 1 then nd := '0000' + nd;
       if Length(nd) = 2 then nd := '000' + nd;
       if length(nd) = 3 then nd := '00' + nd;
       if length(nd) = 4 then nd := '0' + nd;

       ShortDateFormat := 'dd/mm/yy';

       data := FormatDateTime('dd\mm\yy', now);

       Decodedate(date, dia,mes,ano);

       nd := nd + '/' + copy(data,7,8);
       // fim chave primária
       QrDecl_Import.Append;
       
       try
          QrDecl_ImportNR_IDENT_USUARIO.AsString := copy(linha_header,2,15);
       except
          MessageDlg(msg + 'NR_IDENT_USUARIO',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_DECL_IMP_MICRO.AsString := nd;
       except
          MessageDlg(msg + 'NR_DECL_IMP_MICRO',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_TIPO_DECLARACAO.AsString := copy(linha_header,17,2) ;
       except
          MessageDlg(msg + 'CD_TIPO_DECLARACAO',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_TIPO_IMPORTADOR.AsString := copy(linha_header,19,1);
       except
          MessageDlg(msg + 'CD_TIPO_IMPORTADOR',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_IMPORTADOR.AsString :=copy(linha_header,20,14);  
       except
          MessageDlg(msg + 'NR_IMPORTADOR',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_PAIS_IMPORTADOR.AsString :=copy(linha_header,34,3);
       except
          MessageDlg(msg + 'CD_PAIS_IMPORTADOR',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_CPF_REPR_LEGAL.AsString :=copy(linha_header,37,11);
       except
          MessageDlg(msg + 'NR_CPF_REPR_LEGAL',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_VIA_TRANSP_CARG.AsString :=copy(linha_header,48,2);
       except
          MessageDlg(msg + 'CD_VIA_TRANSP_CARG',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNM_TRANSPORTADOR.AsString :=copy(linha_header,50,60); 
       except
          MessageDlg(msg + 'NM_TRANSPORTADOR',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_DCTO_CARGA.AsString :=copy(linha_header,110,18);
       except
          MessageDlg(msg + 'NR_DCTO_CARGA',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_DCTO_CARGA_MAST.AsString :=copy(linha_header,128,18);
       except
          MessageDlg(msg + 'NR_DCTO_CARGA_MAST',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNM_LOCAL_EMBARQUE.AsString :=copy(linha_header,146,50);
       except
          MessageDlg(msg + 'NM_LOCAL_EMBARQUE',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportDT_EMBARQUE.AsString := copy(linha_header,196,8);
       except
          MessageDlg(msg + 'DT_EMBARQUE',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_VEICULO_TRANSP.AsString := copy(linha_header,204,15);
       except
          MessageDlg(msg + 'NR_VEICULO_TRANSP',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNM_VEICULO_TRANSP.AsString := copy(linha_header,219,30);
       except
          MessageDlg(msg + 'NM_VEICULO_TRANSP',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_TIPO_AG_CARGA.AsString := copy(linha_header,249,1); 
       except
          MessageDlg(msg + 'CD_TIPO_AG_CARGA',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_AGENTE_CARGA.AsString := copy(linha_header,250,14); 
       except
          MessageDlg(msg + 'NR_AGENTE_CARGA',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportPB_CARGA.AsString := copy(linha_header,264,20);
       except
          MessageDlg(msg + 'PB_CARGA',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportPL_CARGA.AsString := copy(linha_header,284,20);
       except
          MessageDlg(msg + 'PL_CARGA',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_TIPO_CONSIG.AsString := copy(linha_header,304,1);
       except
          MessageDlg(msg + 'CD_TIPO_CONSIG',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNR_CONSIGNATARIO.AsString := copy(linha_header,305,14);
       except
          MessageDlg(msg + 'NR_CONSIGNATARIO',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportNM_CONSIGNATARIO.AsString := copy(linha_header,319,60);
       except
          MessageDlg(msg + 'NM_CONSIGNATARIO',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_MOEDA_MLE.AsString := copy(linha_header,379,3);
       except
          MessageDlg(msg + 'CD_MOEDA_MLE',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportVL_TOT_MLE_MNEG.AsFloat := (strtofloat(copy(linha_header,382,15)) / (100));
       except
          MessageDlg(msg + 'VL_TOT_MLE_MNEG',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_MOEDA_FRETE.AsString :=copy(linha_header,397,3);
       except
          MessageDlg(msg + 'CD_MOEDA_FRETE',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportVL_TOT_FRT_PREPAID.AsFloat :=(strtofloat(copy(linha_header,400,15)) / (100));
       except
          MessageDlg(msg + 'VL_TOT_FRT_PREPAID',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportVL_TOT_FRT_COLLECT.AsFloat :=(strtofloat(copy(linha_header,415,15)) / (100));
       except
          MessageDlg(msg + 'VL_TOT_FRT_COLLECT',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportVL_FRETE_TNAC_MNEG.AsFloat :=(strtofloat(copy(linha_header,430,15)) / (100));
       except
          MessageDlg(msg + 'VL_FRETE_TNAC_MNEG',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportCD_MOEDA_SEGURO.AsString :=copy(linha_header,445,3);
       except
          MessageDlg(msg + 'CD_MOEDA_SEGURO',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportVL_TOT_SEGURO_MNEG.AsFloat :=(strtofloat(copy(linha_header,448,15)) / (100));
       except
          MessageDlg(msg + 'VL_TOT_SEGURO_MNEG',mtError, mbOKCancel, -1);
       end;
       try
          QrDecl_ImportVL_TOTAL_SEG_MN.AsFloat :=(strtofloat(copy(linha_header,463,15)) / (100));
       except
          MessageDlg(msg + 'VL_TOTAL_SEG_MN',mtError, mbOKCancel, -1);
       end;

       QrDecl_Import.Post;
     end;
  except
    Db.RollbackTrans;
    Db.Connected := false;
    MessageBox(0,'2 - Geração da "DI" não foi concluída.' + #13 +
               'Verifique o Banco de dados e tente novamente.', 'Alerta!', 0+48);
    Application.Terminate;
  end;
end;

procedure TFrmDecl_Imp.InsertRegDetalhesMercad;
begin
  try
    begin
      try
        MercadNR_DECL_IMP_MICRO := nd;
      except
        MessageDlg(msg + 'NR_DECL_IMP_MICRO',mtError, mbOKCancel, -1);
      end;
      try
        MercadNR_OP_IMP_MICRO := copy(linha_header,17,3); //inttostr(na);
      except
        MessageDlg(msg + 'NR_OP_IMP_MICRO',mtError, mbOKCancel, -1);
      end;
      try
        MercadCD_PRODUTO := copy(linha_header,20,16);
      except
        MessageDlg(msg + 'CD_PRODUTO',mtError, mbOKCancel, -1);
      end;
      try
        MercadNM_UN_MEDID_COMERC := copy(linha_header,50,20);
      except
        MessageDlg(msg + 'NM_UN_MEDID_COMERC',mtError, mbOKCancel, -1);
      end;
      try
        MercadVL_UNID_COND_VENDA := copy(linha_header,70,20); //sf
      except
        MessageDlg(msg + 'VL_UNID_COND_VENDA',mtError, mbOKCancel, -1);
      end;
      try
        MercadVL_UNID_LOC_EMB := (strtofloat(copy(linha_header,90,13)) / (100));
      except
        MessageDlg(msg + 'VL_UNID_LOC_EMB',mtError, mbOKCancel, -1);
      end;

    end;
  except
    MessageBox(0,'3 - Geração da "DI" não foi concluída.' + #13 + 'Verifique o Banco de dados e tente novamente.', 'Alerta!', 0+48);
    Application.Terminate;
  end;
end;

procedure TFrmDecl_Imp.InsertRegParcelas;
begin
   try
     with QrParcelas do
       begin
         if not Active then
          Active := True;
         LblStat.Caption := 'Importando registro nº '+ inttostr(i) +'...';
         Progress.Progress := Progress.Progress + 1;
         QrParcelas.Append;

         try
            QrParcelasNR_DECL_IMP_MICRO.AsString := nd;
         except
            MessageDlg(msg + 'NR_DECL_IMP_MICR',mtError, mbOKCancel, -1);
         end;
         try
            QrParcelasNR_OP_IMP_MICRO.AsString := copy(linha_header,17,3); //inttostr(na);
         except
            MessageDlg(msg + 'NR_OP_IMP_MICRO',mtError, mbOKCancel, -1);
         end;
         try
            QrParcelasNU_SEQ_PAG_PREV.AsInteger := np; // Recebe o nº da parcela atual;
         except
            MessageDlg(msg + 'NU_SEQ_PAG_PREV',mtError, mbOKCancel, -1);
         end;
         try
            QrParcelasDT_PREV_PGTO_360.AsString := copy(linha_header,20,6);
         except
            MessageDlg(msg + 'DT_PREV_PGTO_360',mtError, mbOKCancel, -1);
         end;
         try
            QrParcelasVL_PREV_PGTO_360.ASFloat := ((strtofloat(copy(linha_header,26,15))) / (100));
         except
            MessageDlg(msg + 'VL_PREV_PGTO_360',mtError, mbOKCancel, -1);
         end;
         QrParcelas.Post;
       end;
   except
    Db.RollbackTrans;
    Db.Connected := false;
    MessageBox(0,'4 - Geração da "DI" não foi concluída.' + #13 + 'Verifique o Banco de dados e tente novamente.', 'Alerta!', 0+48);
    Application.Terminate;
   end;
end;

procedure TFrmDecl_Imp.InsertRegTributos;
begin
  try
    with QrTributos do
     begin

       if not Active then
        Active := True;

       LblStat.Caption := 'Importando registro nº '+ inttostr(i) +'...';
       Progress.Progress := Progress.Progress + 1;
       QrTributos.Append;
       try
          QrTributosNR_DECL_IMP_MICRO.AsString := nd;
       except
          MessageDlg(msg + 'NR_DECL_IMP_MICRO',mtError, mbOKCancel, -1);
       end;
       try
          QrTributosNR_OP_IMP_MICRO.AsString := copy(linha_header,17,3); //inttostr(na);
       except
          MessageDlg(msg + 'NR_OP_IMP_MICRO',mtError, mbOKCancel, -1);
       end;
       try
          QrTributosCD_RECEITA_IMPOSTO.AsString := copy(linha_header,20,4);
       except
          MessageDlg(msg + 'CD_RECEITA_IMPOSTO',mtError, mbOKCancel, -1);
       end;
       try
          QrTributosCD_TIPO_BENEF_IPI.AsString := '1';
       except
          MessageDlg(msg + 'CD_TIPO_BENEF_IPI',mtError, mbOKCancel, -1);
       end;
       try
          QrTributosPC_ALIQ_NORM_ADVAL.AsFloat := ((strtofloat(copy(linha_header,25,5))) / (100));
       except
          MessageDlg(msg + 'PC_ALIQ_NORM_ADVAL',mtError, mbOKCancel, -1);
       end;
       try
          QrTributosPC_ALIQ_REDUZIDA.AsFloat := ((strtofloat(copy(linha_header,30,5))) / (100));
       except
          MessageDlg(msg + 'PC_ALIQ_REDUZIDA',mtError, mbOKCancel, -1);
       end;

       QrTributos.post;

     end;
  except
    Db.RollbackTrans;
    Db.Connected := false;
    MessageBox(0,'5 - Geração da "DI" não foi concluída.' + #13 + 'Verifique o Banco de dados e tente novamente.', 'Alerta!', 0+48);
    Application.Terminate;
  end;
end;

procedure TFrmDecl_Imp.InsertRegDetalhesMerc;
begin
  try
   with QrDetMercad do
    begin
      if not Active then Active := true;
      LblStat.Caption := 'Importando registro nº '+ inttostr(i) +'...';
      Progress.Progress := Progress.Progress + 1;


          QrDetMercad.append;

          try
              QrDetMercadNR_DECL_IMP_MICRO.AsString := MercadNR_DECL_IMP_MICRO;
          except
              MessageDlg(msg + 'NR_DECL_IMP_MICRO',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadNR_OP_IMP_MICRO.AsString := MercadNR_OP_IMP_MICRO;
          except
              MessageDlg(msg + 'NR_OP_IMP_MICRO',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadNU_SEQ_DETALHE.AsInteger := strtoint(copy(linha_header,20,4));
          except
              MessageDlg(msg + 'NU_SEQ_DETALHE',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadCD_PRODUTO.AsString := MercadCD_PRODUTO;
          except
              MessageDlg(msg + 'CD_PRODUTO',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadQT_MERC_UN_COMERC.AsString := copy(linha_header,24,14);
          except
              MessageDlg(msg + 'QT_MERC_UN_COMERC',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadNM_UN_MEDID_COMERC.AsString := MercadNM_UN_MEDID_COMERC;
          except
              MessageDlg(msg + 'NM_UN_MEDID_COMERC',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadVL_UNID_COND_VENDA.AsString := MercadVL_UNID_COND_VENDA; //sf
          except
              MessageDlg(msg + 'VL_UNID_COND_VENDA',mtError, mbOKCancel, -1);
          end;
          try
              QrDetMercadVL_UNID_LOC_EMB.AsFloat := MercadVL_UNID_LOC_EMB;
          except
              MessageDlg(msg + 'VL_UNID_LOC_EMB',mtError, mbOKCancel, -1);
          end;
          QrDetMercad.post;

    end;
  except
    Db.RollbackTrans;
    Db.Connected := false;
    MessageBox(0,'6 - Geração da "DI" não foi concluída.' + #13 + 'Verifique o Banco de dados e tente novamente.', 'Alerta!', 0+48);
    Application.Terminate;
  end; 
end;


end.
