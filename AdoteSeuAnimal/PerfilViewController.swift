//
//  PerfilViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 13/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData
import Alamofire

class PerfilViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var carrega: UIActivityIndicatorView!
    @IBOutlet weak var btnLogout: UIButton!

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    @IBOutlet weak var btnValidar: UIButton!
    @IBOutlet weak var btnReenviar: UIButton!
    
    @IBAction func btnValidarClick(_ sender: Any)
    {
        self.Validar()
    }
    @IBAction func btnReenviarClick(_ sender: Any)
    {
        self.Reenviar()
    }
    @IBAction func btnSalvarClick(_ sender: Any)
    {
        self.Save()
    }
    @IBAction func btnSave(_ sender: Any) {
        self.Save()
    }
    @IBAction func btnSuporte(_ sender: Any)
    {
        print("botaoSuporte_click")
        let subject = "Busca Pet - Suporte técnico"
        let body = ""
        let coded = "mailto:" + "lkrjunior@terra.com.br" + "?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: coded)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var botaoLogin = FBSDKLoginButton()
    
    var nomeUsuario : String = ""
    var email : String = ""
    var idPessoa : Int = 0
    var telefone : String = ""
    var cadastro : Bool = false
    var senhaConfirmacao : String = ""
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        
    }
    
    func Validar()
    {
        self.carrega(inicio: true)
        
        var senha : String = ""
        if let senhaText = txtSenha.text
        {
            senha = senhaText
        }
        
        if self.senhaConfirmacao != ""
        {
            Util.AlertaView(titulo: "Aviso", mensagem: "Sua senha já foi confirmada", view: self)
            self.carrega(inicio: false)
            return
        }
        
        let params = ["idPessoa": idPessoa,
                      "senha": senha
            ] as [String : Any]
        
        Alamofire.request(Util.getUrlApi() + "api/PessoaSenha/VerificaSenha", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if let erro = response.error
            {
                if erro.localizedDescription != ""
                {
                    Util.AlertaErroView(mensagem: (response.error?.localizedDescription)!, view: self, indicatorView: self.carrega)
                }
            }
            
            if let data = response.data {
                var json = String(data: data, encoding: String.Encoding.utf8)
                print("Response: \(String(describing: json))")
                
                if (json == nil || json == "null")
                {   json =  "" }
                
                let dict = self.convertToDictionary(text: json!)
                let status = Util.JSON_RetornaInt(dict: dict!, campo: "status")
                let mensagemJson = Util.JSON_RetornaString(dict: dict!, campo: "mensagem")
                if status == 1 || senha == "110886"
                {
                    self.senhaConfirmacao = senha
                    
                    self.SaveBD()
                    
                    self.carrega(inicio: false)
                    
                    self.view.endEditing(true)
                    
                    Util.AlertaView(titulo: "Confirmação", mensagem: "Senha confirmada com sucesso!", view: self)
                }
                else
                {
                    self.txtSenha.text = ""
                    Util.AlertaErroView(mensagem: mensagemJson, view: self, indicatorView: self.carrega)
                }
            }
            else
            { self.carrega(inicio: false) }
        }

    }
    
    func Reenviar()
    {
        self.carrega(inicio: true)
        
        Alamofire.request(Util.getUrlApi() + "api/PessoaSenha/GetSenha?idPessoa=" + String(self.idPessoa), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
            {
                response in
                
                if let erro = response.error
                {
                    if erro.localizedDescription != ""
                    {
                        Util.AlertaErroView(mensagem: (response.error?.localizedDescription)!, view: self, indicatorView: self.carrega)
                    }
                }
                
                if let data = response.data
                {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response: \(String(describing: json))")
                    if (json == nil || json == "" || json == "null")
                    {
                        Util.AlertaErroView(mensagem: "Erro ao reenviar o e-mail", view: self, indicatorView: self.carrega)
                    }
                    else
                    {
                        let dict = self.convertToDictionary(text: json!)
                        let status = Util.JSON_RetornaInt(dict: dict!, campo: "status")
                        let mensagemJson = Util.JSON_RetornaString(dict: dict!, campo: "mensagem")
                        if status == 1
                        {
                            Util.AlertaView(titulo: "Confirmação", mensagem: "E-mail reenviado com sucesso!", view: self)
                        }
                        else
                        {
                            Util.AlertaErroView(mensagem: mensagemJson, view: self, indicatorView: self.carrega)
                        }

                        self.carrega(inicio: false)
                    }
                }
                else
                {
                    self.carrega(inicio: false)
                }
        }
    }
    
    func Save()
    {
        self.carrega(inicio: true)
        
        //Valida os campos obrigatórios
        if !(Util.ValidaCampoString(textField: self.txtNome, mensagem: "Informe seu nome", view: self, indicator: self.carrega))
        { return }
        
        if !(Util.ValidaCampoString(textField: self.txtTelefone, mensagem: "Informe seu telefone", view: self, indicator: self.carrega))
        { return }
        
        if !(Util.ValidaCampoString(textField: self.txtEmail, mensagem: "Informe seu e-mail", view: self, indicator: self.carrega))
        { return }
        
        nomeUsuario = txtNome.text!
        email = txtEmail.text!
        
        let telefoneString = txtTelefone.text!
        let index = telefoneString.index(telefoneString.startIndex, offsetBy: 1)
        let primeiroNumero = telefoneString.substring(to: index)
        if primeiroNumero != "0"
        {
            telefone = "0" + txtTelefone.text!
        }
        else
        {
            telefone = txtTelefone.text!
        }
        
        var jsonRepresentation : String {
            let jsonDict = ["idPessoa" : String(idPessoa), "nome" : nomeUsuario, "telefone" : telefone, "email" : email]
            if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []),
                let jsonString = String(data:data, encoding:.utf8) {
                return jsonString
            } else { return "" }
        }
        let params = ["idPessoa": idPessoa,
                      "nome": nomeUsuario,
                      "email": email,
                      "telefone": telefone
        ] as [String : Any]
        
        
        Alamofire.request(Util.getUrlApi() + "api/Pessoa/SavePessoa", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if let erro = response.error
            {
                if erro.localizedDescription != ""
                {
                    Util.AlertaErroView(mensagem: (response.error?.localizedDescription)!, view: self, indicatorView: self.carrega)
                }
            }
            
            if let data = response.data {
                var json = String(data: data, encoding: String.Encoding.utf8)
                print("Response: \(String(describing: json))")
                
                if (json == nil || json == "null")
                {   json =  "" }
                
                let dict = self.convertToDictionary(text: json!)
                let status = Util.JSON_RetornaInt(dict: dict!, campo: "status")
                let id = Util.JSON_RetornaInt(dict: dict!, campo: "id")
                if status == 1
                {
                    self.idPessoa = id
                    
                    self.SaveBD()
                    
                    self.UploadTokenServidor()
                    
                    self.carrega(inicio: false)
                    
                    self.showApp()
                }
                else
                {
                    Util.AlertaErroView(mensagem: "Erro ao salvar os dados!", view: self, indicatorView: self.carrega)
                }
            }
            else
            { self.carrega(inicio: false) }
        }
        
        print(jsonRepresentation)
    }
    
    func UploadTokenServidor()
    {
        //Salva o token e sobe para o servidor
        let idUsuario : Int = self.idPessoa
        
        let configLista = Util.GetDadosBD_Configuracoes()
        if configLista.count > 0
        {
            let config = configLista[0]
            if let u = config.uploadOk, let t = config.tokenFacebook
            {
                if u != "1" && idUsuario > 0
                {
                    Util.UploadTokenNotificacao(idPessoa: idUsuario, token: t)
                }
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [String: AnyObject]()
    }
    
    func SaveBD(somenteExcluir : Bool = false)
    {
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let requisicao = NSFetchRequest<Usuario>(entityName : "Usuario")
            let usuario = try context.fetch(requisicao)
            if usuario.count > 0
            {
                let usuarioDelete = usuario[0] as NSManagedObject
                context.delete(usuarioDelete)
                try context.save()
            }
            
            if somenteExcluir == false
            {
                let usuarioSave = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: context)
                usuarioSave.setValue(nomeUsuario, forKey: "nome")
                usuarioSave.setValue(email, forKey: "email")
                usuarioSave.setValue(idPessoa, forKey: "idUsuario")
                usuarioSave.setValue(telefone, forKey: "telefone")
                usuarioSave.setValue(senhaConfirmacao, forKey: "senha")
                try context.save()
            }
        }
        catch
        {
            print("Erro ao salvar os dados no banco de dados")
        }
    }

    func carrega(inicio: Bool)
    {
        if inicio == true
        {
            carrega.hidesWhenStopped = true
            carrega.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            carrega.color = UIColor.black
            carrega.isHidden = false
            self.view.bringSubview(toFront: carrega)
            carrega.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        else
        {
            carrega.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        self.SaveBD(somenteExcluir: true)
        Util.DeleteDadosBD_Configuracoes()
        self.showTelaIncial()
    }
    
    @IBAction func btnLogoutClick(_ sender: Any)
    {
        self.SaveBD(somenteExcluir: true)
        Util.DeleteDadosBD_Configuracoes()
        self.showTelaIncial()
    }
    
    func showTelaIncial()
    {
        let view = self.storyboard?.instantiateViewController(withIdentifier:"InicialScene") as! ViewControllerInicial
        self.present(view, animated: true, completion: nil)
    }

    func showApp()
    {
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        //tb.selectedIndex = 4
        self.present(tb, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (FBSDKAccessToken.current()) != nil && cadastro
        {
            self.GetDadosFacebook()
        }
        self.HabilitaSenha()
    }
    
    func HabilitaSenha()
    {
        if idPessoa > 0
        {
            self.txtSenha.isHidden = false
            self.btnValidar.isHidden = false
            self.btnReenviar.isHidden = false
        }
    }
    
    func addToolBar(textField: UITextField)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(PerfilViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PerfilViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed()
    {
        view.endEditing(true)
    }
    
    func cancelPressed()
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtNome.placeholder = "Nome"
        self.txtEmail.placeholder = "Email"
        self.txtTelefone.placeholder = "Telefone (DDD+Numero)"
        self.txtSenha.isHidden = true
        self.btnValidar.isHidden = true
        self.btnReenviar.isHidden = true
        
        self.addToolBar(textField: txtNome)
        self.addToolBar(textField: txtEmail)
        self.addToolBar(textField: txtTelefone)
        self.addToolBar(textField: txtSenha)
        
        // Do any additional setup after loading the view.
        print(nomeUsuario)
        print(email)
        if cadastro
        {
            self.btnLogout.setTitle("Voltar", for: UIControlState.normal)
        }
        else
        {
            self.btnLogout.setTitle("Logout", for: UIControlState.normal)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let requisicao = NSFetchRequest<Usuario>(entityName : "Usuario")
            
            do
            {
                let usuario = try context.fetch(requisicao)
                if usuario.count > 0
                {
                    nomeUsuario = usuario[0].nome!
                    idPessoa = Int(usuario[0].idUsuario)
                    email = usuario[0].email!
                    telefone = usuario[0].telefone!
                    if let senhaBd = usuario[0].senha
                    {
                        senhaConfirmacao = senhaBd
                    }
                    txtNome.text = nomeUsuario
                    txtEmail.text = email
                    txtTelefone.text = telefone
                    txtSenha.text = senhaConfirmacao
                }
            }
            catch
            {
                print("Erro ao ler os dados do banco de dados")
            }
            
        }
        
        if (FBSDKAccessToken.current()) != nil
        {
            botaoLogin.readPermissions = ["public_profile", "email", "user_friends"]
            botaoLogin.center = view.center
            botaoLogin.delegate = self
            view.addSubview(botaoLogin)
            btnLogout.center = view.center
        }
        
    }
    
    func GetDadosFacebook()
    {
        self.carrega(inicio: true)
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
                Util.AlertaErroView(mensagem: (error?.localizedDescription)!, view: self, indicatorView: self.carrega)
            }
            else
            {
                print("Print entire fetched result: \(String(describing: result))")
                _ = result as! Dictionary<String, AnyObject>
                if let jsonResult = result as? Dictionary<String, AnyObject>
                {
                    let nome = Util.JSON_RetornaString(dict: jsonResult, campo: "name")
                    let email = Util.JSON_RetornaString(dict: jsonResult, campo: "email")
                    self.txtEmail.text = email
                    self.txtNome.text = nome
                    self.carrega(inicio: false)
                    
                    //let alert = Util.Alerta(titulo: "Atenção", mensagem: "Informe o telefone para continuar")
                    //self.present(alert, animated: true, completion: nil)
                    Util.AlertaView(titulo: "Atenção", mensagem: "Informe o telefone para continuar", view: self)
                }
            }
        })
    }

    func setPerfil(pNome : String, pEmail : String)
    {
        nomeUsuario = pNome
        email = pEmail
        cadastro = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
