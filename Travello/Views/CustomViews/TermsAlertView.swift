//
//  CustomAlertView.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/27/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
import UIKit

class TermsAlertView: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        initialize()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(){
        dialogView.clipsToBounds = true
        //for the black transparent background
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        
        //title text
        let titleLabel = UITextView(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: .greatestFiniteMagnitude))
        let title = "Съгласен съм и приемам Декларацията за поверителност на личните данни и условията за ползване на приложението"
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.attributedText = attributedText(value: title)
        titleLabel.sizeToFit()
        titleLabel.isEditable = false
        dialogView.addSubview(titleLabel)
        
        //separator line
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        //description
        let description = UITextView(frame:CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 300))
        description.frame.origin = CGPoint(x: 8, y: separatorLineView.frame.height + separatorLineView.frame.origin.y)
        description.isEditable = false
        description.text = """
        Моля, прочетете внимателно настоящите условия за ползване преди да използвате приложението „Travello – споделено пътуване“. Тези общи условия представляват ДОГОВОР между Вас и „Travello – споделено пътуване“, с който получавате правото да използвате безплатно услугите на приложението за лични и нетърговски цели при спазване на условията по-долу. Настоящите общи условия имат обвързващо действие само в отношенията между Вас като Потребител на услугите на сайта и Travello – споделено пътуване. Чрез достъпа до (зареждането на) смартфон приложението, Вие се съгласявате да бъдете обвързан от настоящите общи условия и всички последващи промени в тях, както и се задължавате да ги спазвате. В случай, че не сте съгласни с всички общи условия по-долу, моля, не използвайте приложението Travello – споделено пътуване.  - за да използвате услугите на Travello – споделено пътуване е нужно да сте регистриран потребител. - потребителите получават правото да използват услугите на приложението, наричани занапред в този документ “услуги” и само " приложението ", единствено за лични/нетърговски цели. - това смартфон приложението е само за лична и нетърговска употреба. Цялото съдържание и информация на Travello – споделено пътуване са собственост на сайта.  ОПИСАНИЕ НА УСЛУГАТА:  Travello – споделено пътуване е платформа, създадена за подпомагане организирането на пътувания с леки коли. Чрез нея потребителите могат да предлагат превоз от една точка до друга, със собствените си автомобили, или да търсят превоз от други потребители, използващи платформата.  Опциите за потребителски профили са както следва: - Шофьор - Пътник  Потребителски профил “Шофьор” дава достъп до формата за публикуване на обява за споделено пътуване. Потребителски профил “Пътник” дава възможност на потребителя да търси удобен за него превоз от публикуваните обяви и да заявява желанието си да се присъедини към желана такава.
         За да бъде валидна обявата, потребителят трябва да предостави данни като начална и крайна спирка, междинни спирки (ако има такива), дата и час на пътуването.  Тип пътуване:
        При регистриране и публикуване на обява, потребителят има възможност за избор между три опции: - единично – опцията е удобна за потребители, които пътуват нерегулярно; - ежеседмично – опцията е удобна за потребители, пътуващи всяка седмица в еднакви ден и време; - ежемесечно – опцията е за потребители, пътуващи всеки месец, в еднакви ден и време.  Включване към пътуване:  Всеки регистриран потребител може да се включи към дадено пътуване, чрез заявка за това.
        - заявка за заемане на свободно място в пътуване става чрез съобщение към потребителят, който е добавил пътуването. Потребителят, публикувал обявата има право да приеме или откаже заявката. - приложението Travello – споделено пътуване  публикува подробности около маршрута на пътуването, автомобила, с който ще бъде извършено то и времето на пътуването, но подробностите около срещата на шофьора и пътниците са предмет на лична договорка, която следва да се извърши между тях, по най-удобният за тях начин. - Travello – споделено пътуване  не носи отговорност за отказ в последния момент или неявяване от страна на пътниците на мястото на срещата, както и за инциденти или физически или друг тип повреди, които могат да засегнат ползвателите по време на пътуване. - информацията в платформата е собственост на Travello – споделено пътуване  и не може да се ползва от външни лица без изричното съгласие на Travello – споделено пътуване    Задължения на потребителя:  Потребителите на приложението трябва да са над 18 години. Потребителите са напълно отговорни за своите действия и поведение. Потребителите са отговорни за верността и изчерпателността на предоставената информация. При неверни данни, Travello – споделено пътуване  запазва правото си да ограничи/блокира потребителски профили.  Потребителите се задължават да: - променят информацията за пътуването, която пряко или непряко засяга безпроблемната работа на сайта; - своевременно да информират пътника или водача за всяка промяна в графика или маршрута на обявеното пътуване , които биха могли да окажат пряко влияние върху пътуването; - потребителите се задължават да използват сайта само за конкретната услуга;  Потребителите се задължават да не злоупотребяват с информацията в сайта, както и да я използват за: - тормоз, сплашване или клевета; - нарушаване на личния живот и правата на трета страна, дискриминация; - вулгарни, неприлични прояви и с осъдителни цели; - потребителите нямат право да изполват платформата с търговска цел;
        Travello – споделено пътуване  може да се използва свободно за организиране на споделени пътувания с цел намаляне на разходите и съкращаване изгарянето на вредни емисии в атмосферата.  В платформата не могат да се публикуват обяви с търговска цел, както и да се предлагат пътувания с автобуси, минибуси и превозни средства с 8+1 места или тегло над 3.5 тона.  Поведение при пътуване:  - водачът се задължава да спазва всички правила и закони за безопасно пътуване, в това число изправността на предлаганото превозно средство; - водачът е длъжен да представи своите документи (шофьорска книжка, документи на автомобила, застраховки) на пътника, ако бъдат поискани; - пътниците трябва да представят документ за самоличност на водача ако бъдат поискани; - двете страни нямат право да превозват опасни или забранени вещества по време на съвместното пътуване;  Ползвателите се задължават да: - спазват постигнатите договорености; - бъдат учтиви един към друг; - пазят превозното средство чисто и от всякакви материални щети;  ВЪЗНАГРАЖДЕНИЕ И ПЛАЩАНИЯ:  Използването на Travello – споделено пътуване  е напълно безплатно. Travello – споделено пътуване  запазва правото си да добавя нови услуги, да добавя и платени такива, използването на които ще бъде доброволно за всеки потребител.  Заключителни разпоредби:
        Travello – споделено пътуване  няма право да разпространява или използва за услуги, различни от упоменатите в Условията лични данни, освен когато личните данни са изискани от органите за реда.  Администраторът запазва правото си да променя условията за ползване, като информира всички регистрирани потребители.  В случай на неспазване на условия за ползване на проложението, аминистраторът запазва правото си забрани достъпа на потребители до приложението.  Вие се съгласявате да защитавате и предпазвате приложението и трети страни от всякакви вреди, искове от трети страни, свързани с или произтичащи от използването на това приложение и от Ваше нарушение на условията за ползване или на законите, доколкото те не са резултат от небрежност от страна на администраторите на групата.  Потребителите се задължават да информират администраторите за всяко нарушение на условията за ползване от страна на друг потребител, с които те са били в пряк контакт, или по електронната поща.  Администраторът не подлежи на отговорност за всеки инцидент, които може да възникне в хода на пътуването (злополука, кражба, загуба на вещи, закъснение, отмяна и пр.)
        """
        description.textAlignment = .left
        dialogView.addSubview(description)
        
        //Button Cancel View
        let buttonCancel = UIButton()
        buttonCancel.backgroundColor = UIColor.lightGray
        buttonCancel.setTitle("Отказ", for: .normal)
        buttonCancel.layer.cornerRadius = 3
        buttonCancel.setTitleColor(UIColor.black, for: .normal)
        buttonCancel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        buttonCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onCancel)))
        
        //Button Accept View
        let buttonAccept = UIButton()
        buttonAccept.backgroundColor = UIColor.lightGray
        buttonAccept.setTitle("приемам", for: .normal)
        buttonAccept.setTitleColor(UIColor.black, for: .normal)
        buttonAccept.layer.cornerRadius = 3
        buttonAccept.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        buttonAccept.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        buttonAccept.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onAgree)))
        
        //Stack View
        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.fillEqually
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing   = 8.0
        
        stackView.frame.origin = CGPoint(x: 8, y: description.frame.height + description.frame.origin.y + 8)
        stackView.frame.size = CGSize(width: dialogViewWidth - 16 , height: 40)
        
        stackView.addArrangedSubview(buttonCancel)
        stackView.addArrangedSubview(buttonAccept)
        stackView.translatesAutoresizingMaskIntoConstraints = true
        
        dialogView.addSubview(stackView)
        
        let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + description.frame.height + stackView.frame.height + 8
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    @objc func onCancel(){
        dismiss(animated: true)
        exit(0)
    }
    
    @objc func onAgree(){
        dismiss(animated: true)
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String{
            //save the version in userDefaults
            UserDefaults.standard.set(version, forKey: Constants.VERSION)
        }
        
    }
    
    func attributedText(value: String) -> NSAttributedString {
        
        let string = value as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15.0)])
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15.0)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: value))
        // 4
        return attributedString
    }
    
}
