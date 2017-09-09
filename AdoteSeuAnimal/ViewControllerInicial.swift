//
//  ViewControllerInicial.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 12/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData

class ViewControllerInicial: UIViewController, FBSDKLoginButtonDelegate {
    
    let botaoLogin = FBSDKLoginButton()
    var idUsuario : Int = 0
    var nomeUsuario : String = ""
    var email : String = ""
    var telefone : String = ""
    
    @IBAction func btnCadastro(_ sender: Any)
    {
        self.showTelaPerfil()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        botaoLogin.readPermissions = ["public_profile", "email", "user_friends"]
        botaoLogin.center = view.center
        botaoLogin.addTarget(self, action: #selector(botaoLoginClick), for: UIControlEvents.touchUpInside)
        botaoLogin.delegate = self
        view.addSubview(botaoLogin)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requisicao = NSFetchRequest<Usuario>(entityName : "Usuario")
        
        do
        {
            //Exemplo Save
            //let usuarioSave = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: context)
            //usuarioSave.setValue("teste", forKey: "nome")
            //try context.save()
            
            
            let usuario = try context.fetch(requisicao)
            if usuario.count > 0
            {
                nomeUsuario = usuario[0].nome!
                idUsuario = Int(usuario[0].idUsuario)
                email = usuario[0].email!
                print(nomeUsuario)
                
                //Exemplo delete 
                //let usuarioDelete = usuario[0] as NSManagedObject
                //context.delete(usuarioDelete)
                //try context.save()
            }
        }
        catch
        {
            print("Erro ao recuperar os dados do SQLite")
        }
        
        Util.FiltrarSave(filtros: ClassFiltrar(), limpar: true)
        Util.CombosSaveCache(combos: "")
        
        if idUsuario > 0
        {
            self.showTelaInicial()
        }
        
        //if let accessToken = FBSDKAccessToken.current()
        //{
        //    NSLog("Logado " + accessToken.tokenString)
        //}
        //else
        //{
        //    NSLog("Não Logado")
        //}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if idUsuario > 0
        {
            self.showTelaInicial()
        }
    }
    
    func showTelaInicial()
    {
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        //tb.selectedIndex = 4
        self.present(tb, animated: true, completion: nil)
    }
    
    func showTelaPerfil()
    {
        //let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        //tb.selectedIndex = 4
        //self.present(tb, animated: true, completion: nil)
        
        let view = self.storyboard?.instantiateViewController(withIdentifier:"PerfilScene") as! PerfilViewController
        view.setPerfil(pNome: nomeUsuario, pEmail: email)
        self.present(view, animated: true, completion: nil)
    }
    
    func botaoLoginClick()
    {
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                self.GetDadosFacebook()
                self.showTelaPerfil()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
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
            }
        })
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
