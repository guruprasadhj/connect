import 'package:connect/animations/FadeAnimation.dart';
import 'package:connect/views/intros/register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  bool hideIcon = false;

  @override
  void initState() {

    super.initState();
    _scaleController=AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );
    _scaleAnimation = Tween<double>(
        begin: 1.0, end:0.8 ).animate(_scaleController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _widthController.forward();
      }
    });

    _widthController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );

    _widthAnimation = Tween<double>(
        begin: 80.0,
        end: 300.0
    ).animate(_widthController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _positionController.forward();
      }
    });

    _positionController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _positionAnimation = Tween<double>(
        begin: 0.0,
        end: 215.0
    ).animate(_positionController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        setState(() {
          hideIcon = true;
        });
        _scale2Controller.forward();

      }
    });

    _scale2Controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _scale2Animation = Tween<double>(
      begin: 1.0,
      end: 60.0,
    ).animate(_scale2Controller)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
       Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: Register()));
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    final double width =MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      body: Container(
        width: double.infinity,

        child: Center(
          child: Stack(
            children: <Widget>[


              Positioned(top: -50,child: FadeAnimation(1,Container(
                width: width ,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/one.png'),
                      fit:BoxFit.cover
                  ),
                ),)
              )),
              Positioned(top: -50,left: (width/2)-240,
                  child: FadeAnimation(1.6, Container(

                    width: 480 ,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/one.png'),
                          fit:BoxFit.cover
                      ),
                    ),)
                  )),
              Positioned(top: -50,left: (width/2)-240,
                child: FadeAnimation(1.6, Container(

                  width: 480 ,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/two.png'),
                        fit:BoxFit.cover
                    ),
                  ),)
                ),),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(1,Text("Hello !!",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold))),
                    SizedBox(height: 15,),
                    FadeAnimation(1.3,Text("We promise you that you'll have most \nfuss-free time with us ever.",style: TextStyle(color: Colors.white.withOpacity(.7),),)),
                    SizedBox(height: 180,),
                    FadeAnimation(1.6, AnimatedBuilder(
                      animation:_scaleController,
                      builder:(context,child)=> Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _widthController,
                            builder: (context,child)=> Container(
                              width: _widthAnimation.value,

                              height: 80,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xffd80147).withOpacity(.4)
                              ),
                              child:GestureDetector(
                                onTap: (){
                                  _scaleController.forward();
                                },
                                child: Stack(
                                    children: <Widget>[
                                      AnimatedBuilder(
                                        animation: _positionController,
                                        builder: (context,child)=> Positioned(
                                          left: _positionAnimation.value,
                                          child: AnimatedBuilder(
                                            animation: _scale2Controller,
                                            builder: (context,child)=> Transform.scale(
                                              scale: _scale2Animation.value ,
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(shape: BoxShape.circle,
                                                    color: Color(0xffd80147)
                                                ),
                                                child: hideIcon== false ? Icon(Icons.arrow_forward_ios,color: Colors.white,):Container(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),]
                                ),
                              ) ,
                            ),
                          ),
                        ),),
                    )
                    ),
                    SizedBox(height: 60,)

                  ],

                ),
              )

            ],

          ),
        ),
      ),


    );
  }
}
