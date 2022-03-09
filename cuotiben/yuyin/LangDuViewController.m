//
//  LangDuViewController.m
//  xunfeitest
//
//  Created by 陈志超 on 2022/3/2.
//

#import "LangDuViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface LangDuViewController ()<AVSpeechSynthesizerDelegate>
@property (nonatomic,strong)AVSpeechSynthesizer *avSpeaker;
@end

@implementation LangDuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if(self.text.length)
//        [self SetYuyinLangDu:self.text];
    // Do any additional setup after loading the view.
}
-(void)readtext:(NSString *)text{
    [self SetYuyinLangDu:text];
}
-(void)stopread{
    [_avSpeaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
-(void)SetYuyinLangDu:(NSString*)text{

    //初始化语音合成器
    if (!self.avSpeaker) {
        self.avSpeaker = [[AVSpeechSynthesizer alloc]init];
        self.avSpeaker.delegate = self;
    }
//    _avSpeaker = [[AVSpeechSynthesizer alloc] init];
//    _avSpeaker.delegate = self;
    //初始化要说出的内容
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    //设置语速,语速介于AVSpeechUtteranceMaximumSpeechRate和AVSpeechUtteranceMinimumSpeechRate之间
    //AVSpeechUtteranceMaximumSpeechRate
    //AVSpeechUtteranceMinimumSpeechRate
    //AVSpeechUtteranceDefaultSpeechRate
    utterance.rate = 0.5;
            
    //设置音高,[0.5 - 2] 默认 = 1
    //AVSpeechUtteranceMaximumSpeechRate
    //AVSpeechUtteranceMinimumSpeechRate
    //AVSpeechUtteranceDefaultSpeechRate
    utterance.pitchMultiplier = 1;
            
    //设置音量,[0-1] 默认 = 1
    utterance.volume = 1;

    //读一段前的停顿时间
    utterance.preUtteranceDelay = 0.5;
    //读完一段后的停顿时间
    utterance.postUtteranceDelay = 0.5;
            
    //设置声音,是AVSpeechSynthesisVoice对象
    //AVSpeechSynthesisVoice定义了一系列的声音, 主要是不同的语言和地区.
    //voiceWithLanguage: 根据制定的语言, 获得一个声音.
    //speechVoices: 获得当前设备支持的声音
    //currentLanguageCode: 获得当前声音的语言字符串, 比如”ZH-cn”
    //language: 获得当前的语言
    //通过特定的语言获得声音
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //通过voicce标示获得声音
    //AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithIdentifier:AVSpeechSynthesisVoiceIdentifierAlex];
    utterance.voice = voice;
    //开始朗读
    [_avSpeaker speakUtterance:utterance];
}
#pragma mark - AVSpeechSynthesizerDelegate
//已经开始
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{

    NSLog(@"开始播放");
}
//已经说完
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"完成播放");
//    [self SetYuyinLangDu:@"2222222年好是短发短发短发"];
    if ([self.avSpeaker isSpeaking]) {
        [self.avSpeaker pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }//如果朗读要循环朗读，可以在这里再次调用朗读方法
//[_avSpeaker speakUtterance:utterance];
//    [self dismissViewControllerAnimated:NO completion:nil];
}
//已经暂停
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"暂停播放");
}
//已经继续说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"恢复播放");
}
//已经取消说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{

}
//将要说某段话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
