//
//  YuYinViewController.m
//  xunfeitest
//
//  Created by 陈志超 on 2022/3/1.
//
#define LoadingText @"正在录音。。。"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#import "YuYinViewController.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
@interface YuYinViewController ()<SFSpeechRecognizerDelegate>
@property (nonatomic,strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic,strong) AVAudioEngine *audioEngine;
@property (nonatomic,strong) SFSpeechRecognitionTask * recognitionTask;
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest * recognitionRequest;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UITextView *tv;
@property (nonatomic,strong) UILabel *lab;
@end

@implementation YuYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBtnAndTextViewUI];
    [self RecognizerAuthorizationed];
    // Do any additional setup after loading the view.
}

-(void)setBtnAndTextViewUI{
    self.view.backgroundColor = [UIColor colorWithWhite:0.1f alpha: 0.7];
    if (_btn) {
        _btn=nil;
    }
    if(_tv)
        _tv = nil;
    if(_lab)
        _lab = nil;
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height-200, 100, 100)];
        _tv =[[UITextView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 100, 200, 200)];
    _tv.layer.cornerRadius = 10;
    _tv.textAlignment = NSTextAlignmentCenter;
        _btn.enabled = NO;
        _tv.text = LoadingText;
    _lab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, Width, 30)];
    _lab.textColor = [UIColor redColor];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.text = @"蓝色表示正在录音，灰色表示没有录音";
        [_btn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
    
        [_btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_tv];
        [self.view addSubview:_btn];
    [self.view addSubview:_lab];
}

-(void)RecognizerAuthorizationed{
        [SFSpeechRecognizer  requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                        self.btn.enabled = NO;
                        [self.btn setTitle:@"语音识别未授权" forState:UIControlStateDisabled];
                        break;
                    case SFSpeechRecognizerAuthorizationStatusDenied:
                        self.btn.enabled = NO;
                        [self.btn setTitle:@"用户未授权使用语音识别" forState:UIControlStateDisabled];
                        break;
                    case SFSpeechRecognizerAuthorizationStatusRestricted:
                        self.btn.enabled = NO;
                        [self.btn setTitle:@"语音识别在这台设备上受到限制" forState:UIControlStateDisabled];
    
                        break;
                    case SFSpeechRecognizerAuthorizationStatusAuthorized:
                        self.btn.enabled = YES;
                        [self.btn setTitle:@"开始录音" forState:UIControlStateNormal];
                        break;
    
                    default:
                        break;
                }
    
            });
        }];
}
-(void)btnclicked{
 
    if (self.audioEngine.isRunning) {
        [self endRecording];
        [_btn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        _returnblock(self.tv.text);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else{
        [self startRecording];
        [_btn setImage:[UIImage imageNamed:@"yuyin-2"] forState:UIControlStateNormal];
        
    }

}

- (void)endRecording{
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
    }
    
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    self.btn.enabled = NO;
    
    if ([self.tv.text isEqualToString:LoadingText]) {
        self.tv.text = @"";
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
}
- (void)startRecording{
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(inputNode, @"录入设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) weakSelf = self;
    _recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL isFinal = NO;
        if (result) {
            strongSelf.tv.text = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        if (error || isFinal) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionTask = nil;
            strongSelf.recognitionRequest = nil;
            strongSelf.btn.enabled = YES;

        }
        
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
//    self.tv.text = LoadingText;
}
#pragma mark - property
- (AVAudioEngine *)audioEngine{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
- (SFSpeechRecognizer *)speechRecognizer{
    if (!_speechRecognizer) {
        //腰围语音识别对象设置语言，这里设置的是中文
        NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        _speechRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}
#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        self.btn.enabled = YES;
    }
    else{
        self.btn.enabled = NO;

    }
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
