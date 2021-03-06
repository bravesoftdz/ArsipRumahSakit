unit USaveDokter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, frxClass, frxPreview, frxDBSet, frxExportPDF,
  StdCtrls, ExtCtrls;

type
  TFSimpanScanDokter = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    frxPDFExport1: TfrxPDFExport;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxPreview1: TfrxPreview;
    procedure frxReport1BeforePrint(Sender: TfrxReportComponent);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  procedure DelFilesFrom(Directory, Filemask : string; DelSubDirs : Boolean);
  function waktu : string;
  end;

var
  FSimpanScanDokter: TFSimpanScanDokter;

implementation

uses UScanDokter, UPindaiDokter;

{$R *.dfm}

{ TForm3 }

procedure TFSimpanScanDokter.DelFilesFrom(Directory, Filemask: string;
  DelSubDirs: Boolean);
  var Sourcelst : string;
  FOS : TSHFileOpStruct;
begin
  FillChar(FOS, SizeOf(FOS),0);
  FOS.Wnd := Application.MainForm.Handle;
  FOS.wFunc := FO_DELETE;
  Sourcelst := Directory+'\'+Filemask+#0;
  FOS.pFrom := PChar(Sourcelst);
  if not DelSubDirs then
  FOS.fFlags := FOS.fFlags or FOF_FILESONLY;
  FOS.fFlags := FOS.fFlags or FOF_NOCONFIRMATION;
  SHFileOperation(FOS);

end;

function TFSimpanScanDokter.waktu: string;
var tgl : TDateTime;
begin
  tgl := Now();
  Result := FormatDateTime('yyyy', tgl);
end;

procedure TFSimpanScanDokter.frxReport1BeforePrint(Sender: TfrxReportComponent);
var img:TfrxComponent;
begin
  try
    img:=frxReport1.FindObject('Picture1');
    //TfrxPictureView(img).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+
    //'Gambar_scan\'+Form2.VirtualTable1.FieldValues['Image']);
    except
      ShowMessage('Objek Tidak Ditemukan');

end;
end;

procedure TFSimpanScanDokter.FormShow(Sender: TObject);
begin
frxReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'PreviewScanPdf.fr3');
frxReport1.FileName:=ExtractFilePath(Application.ExeName)+'PreviewScanPdf.fr3';
frxReport1.ShowReport();
end;

procedure TFSimpanScanDokter.Button1Click(Sender: TObject);
var PDFku : TfrxCustomExportFilter;
namapdf,lokasihapus : string;
begin
  if asalscan = 0 then
  begin
    namapdf :=FPindaiDokter.Edit1.Text+'-'+fpindaidokter.Edit2.Text+'-'+waktu+'Surat-masuk.pdf';
    PDFku:=TfrxCustomExportFilter(frxPDFExport1);
    PDFku.ShowDialog := False;
    PDFku.FileName:= ExtractFilePath(Application.ExeName)+'\FileDokterPDF\'+namapdf;
    frxReport1.PrepareReport(False);
    frxReport1.Export(PDFku);
    FPindaiDokter.Label8.Caption:=namapdf;
  end;
  FScanDok.VirtualTable1.Clear;
  lokasihapus:=(ExtractFilePath(Application.ExeName)+'\Gambar_scan\');
  DelFilesFrom(lokasihapus,'*.*', FALSE);
  Close;
  end;

end.
 