unit Pseudocor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Global;

type
  TFormPseudocor = class(TForm)
    LNegativo: TLabel;
    Label1: TLabel;
    BtAbrirImagem: TButton;
    BtAplicarPseudocor: TButton;
    GroupBox2: TGroupBox;
    Imagem1: TImage;
    OpenDialogImage: TOpenDialog;
    GroupBox1: TGroupBox;
    Imagem2: TImage;
    procedure BtAplicarPseudocorClick(Sender: TObject);
    procedure BtAbrirImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPseudocor: TFormPseudocor;
  ImagemPGM1: ImagemPGM;

implementation

{$R *.dfm}

procedure TFormPseudocor.BtAbrirImagemClick(Sender: TObject);
begin
  if OpenDialogImage.Execute
  then
  begin
    ImagemPGM1 := AbrirImagem(OpenDialogImage.FileName);
    LimparImagem(Imagem1);
    DesenharImagem(ImagemPGM1, Imagem1);
  end;
end;

procedure TFormPseudocor.BtAplicarPseudocorClick(Sender: TObject);
var
  ImagemPGM2: ImagemPGM;
begin
  ImagemPGM2 := NormalizarImagem(ImagemPGM1);
  ImagemPGM2 := AplicarPseudocor(ImagemPGM2, ImagemPGM2.CinzaMax);
  LimparImagem(Imagem2);
  DesenharImagem(ImagemPGM2, Imagem2);
end;

end.
