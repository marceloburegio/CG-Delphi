unit Filtros;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Global;

type
  TFormFiltros = class(TForm)
    LNegativo: TLabel;
    BtAbrirImagem: TButton;
    BtMedia: TButton;
    OpenDialogImage: TOpenDialog;
    BtPassaAlta: TButton;
    BtMediana: TButton;
    BtRoberts: TButton;
    BtRobertsCruzado: TButton;
    BtPrewitt: TButton;
    BtSobel: TButton;
    BtAltoReforco: TButton;
    GroupBox1: TGroupBox;
    Imagem1: TImage;
    GroupBox2: TGroupBox;
    Imagem2: TImage;
    procedure BtAltoReforcoClick(Sender: TObject);
    procedure BtSobelClick(Sender: TObject);
    procedure BtPrewittClick(Sender: TObject);
    procedure BtRobertsCruzadoClick(Sender: TObject);
    procedure BtRobertsClick(Sender: TObject);
    procedure BtMedianaClick(Sender: TObject);
    procedure BtPassaAltaClick(Sender: TObject);
    procedure BtMediaClick(Sender: TObject);
    procedure BtAbrirImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFiltros: TFormFiltros;
  ImagemPGMOrig: ImagemPGM;

implementation

{$R *.dfm}

procedure TFormFiltros.BtAbrirImagemClick(Sender: TObject);
begin
  if OpenDialogImage.Execute
  then
  begin
    ImagemPGMOrig := AbrirImagem(OpenDialogImage.FileName);
    LimparImagem(Imagem2);
    DesenharImagem(ImagemPGMOrig, Imagem1);
  end;
end;

procedure TFormFiltros.BtMediaClick(Sender: TObject);
var
  ImagemPGM1: ImagemPGM;
  Mascara: TRealBiDynArray;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Filtro Média
  Mascara[0][0] := 0.1;  Mascara[1][0] := 0.1;  Mascara[2][0] := 0.1;
  Mascara[0][1] := 0.1;  Mascara[1][1] := 0.1;  Mascara[2][1] := 0.1;
  Mascara[0][2] := 0.1;  Mascara[1][2] := 0.1;  Mascara[2][2] := 0.1;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Normalizando a imagem
  ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtMedianaClick(Sender: TObject);
var
  ImagemPGM1: ImagemPGM;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Aplicando a Mediana na imagem
  ImagemPGM1 := AplicarMediana(ImagemPGMOrig);

  // Normalizando a imagem
  ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtPassaAltaClick(Sender: TObject);
var
  ImagemPGM1: ImagemPGM;
  Mascara: TRealBiDynArray;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Filtro Passa Alta
  Mascara[0][0] := -1/9; Mascara[1][0] := -1/9; Mascara[2][0] := -1/9;
  Mascara[0][1] := -1/9; Mascara[1][1] := 8/9;  Mascara[2][1] := -1/9;
  Mascara[0][2] := -1/9; Mascara[1][2] := -1/9; Mascara[2][2] := -1/9;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, false);

  // Normalizando a imagem
  //ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtRobertsClick(Sender: TObject);
var
  ImagemPGM1, ImagemPGM2: ImagemPGM;
  Mascara: TRealBiDynArray;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Filtro Roberts em X
  Mascara[0][0] := 0;    Mascara[1][0] := 0;    Mascara[2][0] := 0;
  Mascara[0][1] := 0;    Mascara[1][1] := 1;    Mascara[2][1] := 0;
  Mascara[0][2] := 0;    Mascara[1][2] := -1;   Mascara[2][2] := 0;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Filtro Roberts em Y
  Mascara[0][0] := 0;    Mascara[1][0] := 0;    Mascara[2][0] := 0;
  Mascara[0][1] := 0;    Mascara[1][1] := 1;    Mascara[2][1] := -1;
  Mascara[0][2] := 0;    Mascara[1][2] := 0;    Mascara[2][2] := 0;
  
  // Aplicando a Máscara
  ImagemPGM2 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Somando o Roberts em X com o Roberts em Y
  ImagemPGM1 := SomarImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  //ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtRobertsCruzadoClick(Sender: TObject);
var
  ImagemPGM1, ImagemPGM2: ImagemPGM;
  Mascara: TRealBiDynArray;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Filtro Roberts Cruzado em X
  Mascara[0][0] := 0;    Mascara[1][0] := 0;    Mascara[2][0] := 0;
  Mascara[0][1] := 0;    Mascara[1][1] := 1;    Mascara[2][1] := 0;
  Mascara[0][2] := 0;    Mascara[1][2] := 0;    Mascara[2][2] := -1;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Filtro Roberts Cruzado em Y
  Mascara[0][0] := 0;    Mascara[1][0] := 0;    Mascara[2][0] := 0;
  Mascara[0][1] := 0;    Mascara[1][1] := 0;    Mascara[2][1] := 1;
  Mascara[0][2] := 0;    Mascara[1][2] := -1;   Mascara[2][2] := 0;
  
  // Aplicando a Máscara
  ImagemPGM2 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Somando o Roberts Cruzado em X com o Roberts Cruzado em Y
  ImagemPGM1 := SomarImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  //ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtPrewittClick(Sender: TObject);
var
  ImagemPGM1, ImagemPGM2: ImagemPGM;
  Mascara: TRealBiDynArray;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Filtro Prewitt em X
  Mascara[0][0] := -1;   Mascara[1][0] := -1;   Mascara[2][0] := -1;
  Mascara[0][1] := 0;    Mascara[1][1] := 0;    Mascara[2][1] := 0;
  Mascara[0][2] := 1;    Mascara[1][2] := 1;    Mascara[2][2] := 1;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Filtro Prewitt em Y
  Mascara[0][0] := -1;   Mascara[1][0] := 0;    Mascara[2][0] := 1;
  Mascara[0][1] := -1;   Mascara[1][1] := 0;    Mascara[2][1] := 1;
  Mascara[0][2] := -1;   Mascara[1][2] := 0;    Mascara[2][2] := 1;
  
  // Aplicando a Máscara
  ImagemPGM2 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Somando o Gradiente em X com o Gradiente em Y
  ImagemPGM1 := SomarImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  //ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtAltoReforcoClick(Sender: TObject);
var
  ImagemPGM1: ImagemPGM;
  Mascara: TRealBiDynArray;
  AStr: string;
  A: real;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Obtendo o valor de A
  AStr := InputBox('Valor de "A" (Ex.: 1,1)', '', '');
  if (AStr = '') then
    Exit;
  A := StrToFloat(AStr);

  if (A < 1) then
  begin
    Application.MessageBox('O valor de "A" deve ser maior ou igual a 1!', 'ATENÇÃO', MB_OK);
    Exit;
  end;
  A := (A * 9) - 1;

  // Filtro Alto Reforço
  Mascara[0][0] := -1;   Mascara[1][0] := -1;   Mascara[2][0] := -1;
  Mascara[0][1] := -1;   Mascara[1][1] := A;    Mascara[2][1] := -1;
  Mascara[0][2] := -1;   Mascara[1][2] := -1;   Mascara[2][2] := -1;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Normalizando a imagem
  ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

procedure TFormFiltros.BtSobelClick(Sender: TObject);
var
  ImagemPGM1, ImagemPGM2: ImagemPGM;
  Mascara: TRealBiDynArray;
begin
  // Criando a imagem resultante
  ImagemPGM1 := CriarImagem(ImagemPGMOrig.Largura, ImagemPGMOrig.Altura, ImagemPGMOrig.CinzaMax);

  // Setando as dimensoes da mascara
  SetLength(Mascara, 3, 3);

  // Filtro Sobel em X
  Mascara[0][0] := -1;   Mascara[1][0] := -2;   Mascara[2][0] := -1;
  Mascara[0][1] := 0;    Mascara[1][1] := 0;    Mascara[2][1] := 0;
  Mascara[0][2] := 1;    Mascara[1][2] := 2;    Mascara[2][2] := 1;

  // Aplicando a Máscara
  ImagemPGM1 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Filtro Sobel em Y
  Mascara[0][0] := -1;   Mascara[1][0] := 0;    Mascara[2][0] := 1;
  Mascara[0][1] := -2;   Mascara[1][1] := 0;    Mascara[2][1] := 2;
  Mascara[0][2] := -1;   Mascara[1][2] := 0;    Mascara[2][2] := 1;
  
  // Aplicando a Máscara
  ImagemPGM2 := AplicarMascara(ImagemPGMOrig, Mascara, true);

  // Somando o Gradiente em X com o Gradiente em Y
  ImagemPGM1 := SomarImagens(ImagemPGM1, ImagemPGM2);

  // Normalizando a imagem
  //ImagemPGM1 := NormalizarImagem(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM1, Imagem2);
end;

end.
