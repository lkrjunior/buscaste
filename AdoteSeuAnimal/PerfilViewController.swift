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

class PerfilViewController: UIViewController, FBSDKLoginButtonDelegate
{
    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var btnLogout: UIButton!

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    
    @IBAction func btnSalvarClick(_ sender: Any)
    {
        self.showApp()
    }
    var botaoLogin = FBSDKLoginButton()
    
    var nomeUsuario : String = ""
    var email : String = ""
    var cadastro : Bool = false
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        
    }
    
    func carrega(inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = self.view.center
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            self.view.addSubview(carregamento)
            carregamento.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else
        {
            carregamento.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        self.showTelaIncial()
    }
    
    @IBAction func btnLogoutClick(_ sender: Any)
    {
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
        self.carrega(inicio: true)
        if (FBSDKAccessToken.current()) != nil && cadastro
        {
            self.GetDadosFacebook()
        }
        self.carrega(inicio: false)
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
