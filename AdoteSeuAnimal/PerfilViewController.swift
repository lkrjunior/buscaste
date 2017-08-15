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

class PerfilViewController: UIViewController, FBSDKLoginButtonDelegate
{
    
    @IBOutlet weak var carrega: UIActivityIndicatorView!
    @IBOutlet weak var btnLogout: UIButton!

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    
    @IBAction func btnSalvarClick(_ sender: Any)
    {
        self.Save()
    }
    
    var botaoLogin = FBSDKLoginButton()
    
    var nomeUsuario : String = ""
    var email : String = ""
    var idPessoa : Int = 0
    var telefone : String = ""
    var cadastro : Bool = false
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        
    }
    
    func Save()
    {
        self.carrega(inicio: true)
        nomeUsuario = txtNome.text!
        telefone = txtTelefone.text!
        email = txtEmail.text!
        
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
        
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Pessoa/SavePessoa", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("Response: \(String(describing: json))")
                
                let dict = self.convertToDictionary(text: json!)
                let status = dict?["status"] as! Int
                let id = dict?["id"] as! Int
                if status == 1
                {
                    self.idPessoa = id
                    
                    self.SaveBD()
                    
                    self.carrega(inicio: false)
                    
                    self.showApp()
                }
            }
        }
        
        print(jsonRepresentation)
    }
    
    func convertToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
            carrega.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            carrega.isHidden = false
            carrega.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else
        {
            carrega.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        self.SaveBD(somenteExcluir: true)
        self.showTelaIncial()
    }
    
    @IBAction func btnLogoutClick(_ sender: Any)
    {
        self.SaveBD(somenteExcluir: true)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    txtNome.text = nomeUsuario
                    txtEmail.text = email
                    txtTelefone.text = telefone
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
            }
            else
            {
                print("Print entire fetched result: \(String(describing: result))")
                _ = result as! Dictionary<String, AnyObject>
                if let jsonResult = result as? Dictionary<String, AnyObject>
                {
                    guard let nome = jsonResult["name"] as? String else { return }
                    guard let email = jsonResult["email"] as? String else { return }
                    self.txtEmail.text = email
                    self.txtNome.text = nome
                    self.carrega(inicio: false)
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
