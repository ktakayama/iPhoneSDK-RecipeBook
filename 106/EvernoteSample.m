// 「レシピ106 :Evernoteと連携する」のサンプルコード (P.279)

@interface EvernoteSample : NSObject {
}
- (BOOL) upload:(NSString *)path withMime:(NSString *)mime
       username:(NSString*)username password:(NSString*)password
    consumerKey:(NSString*)conKey consumerSercret:(NSString*)conSercret
     clientName:(NSString*)clientName serverUrl:(NSString*)serverUrl;
@end

@implementation EvernoteSample
-(EDAMData*) readFileAsData:(NSString*)fileName {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    NSData *body = [NSData dataWithContentsOfFile:fileName];
    EDAMData *data = [[[EDAMData alloc]init]autorelease];

    CC_MD5([body bytes], [body length], digest);
    NSData* md5data =
    [[[[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH] copy]
     autorelease];

    [data setSize:[body length]];
    [data setBodyHash:md5data];
    [data setBody:body];
    return data;
}

-(NSString*)dataToHex:(NSData*)data {
    NSMutableString *sb = [[NSMutableString alloc]init];
    for (long i=0; i<[data length];i++) {
        UInt8 intVal = 0xff & *((UInt8*)[data bytes]+i);
        [sb appendString:[NSString stringWithFormat:@"%02x",intVal]  ];
    }
    return sb;
}

- (BOOL) upload:(NSString *)path withMime:(NSString *)mime
       username:(NSString*)username password:(NSString*)password
    consumerKey:(NSString*)conKey consumerSercret:(NSString*)conSercret
     clientName:(NSString*)clientName serverUrl:(NSString*)serverUrl {
    NSString *errormsg;
    NSString *errorreason;
    //使用可能なMimeタイプは以下のいずれか
    // image/gif
    // image/jpeg
    // image/png
    // audio/wav
    // audio/mpeg
    // application/vnd.evernote.ink
    // application/pdf

    //事前にネットワークが使用可能かチェックしておくこと

    // Set up the UserStore and check that we can talk to the server
    NSString *userStoreUrl = [NSString stringWithFormat:@"%@%@",
                              serverUrl,@"edam/user"];
    THTTPClient *userStoreTrans = [[THTTPClient alloc]
                                initWithURL:[NSURL URLWithString:userStoreUrl]];
    [userStoreTrans autorelease];
    TBinaryProtocol *userStorePort =
    [[TBinaryProtocol alloc] initWithTransport:userStoreTrans];
    [userStorePort autorelease];
    EDAMUserStoreClient *userStore = [[EDAMUserStoreClient alloc]
                                      initWithProtocol:userStorePort];
    [userStore autorelease];

    // プロトコルバージョンのチェック
    BOOL versionOk = [userStore checkVersion:clientName
                                :[EDAMUserStoreConstants EDAM_VERSION_MAJOR]
                                :[EDAMUserStoreConstants EDAM_VERSION_MINOR]];
    if (!versionOk) {
        errormsg = @"Authentication Error";
        errorreason = @"Incomatible EDAM client protocol version";
        NSLog(@"%@ %@",errormsg,errorreason);
        return NO;
    }

    // 認証
    EDAMAuthenticationResult *authResult =
    [userStore authenticate:username :password :conKey :conSercret];
    EDAMUser *user = [authResult user];
    NSString *authToken = [authResult authenticationToken];

    // NoteStoreを作成
    NSLog(@"Notes for %@:",[user username]);
    NSString *noteStoreUrl = [NSString stringWithFormat:@"%@%@%@",
                              serverUrl,@"edam/note/",[user shardId]];
    THTTPClient *noteStoreTrans = [[THTTPClient alloc]
                                initWithURL:[NSURL URLWithString:noteStoreUrl]];
    [noteStoreTrans autorelease];
    TBinaryProtocol *noteStorePort =
    [[TBinaryProtocol alloc] initWithTransport:noteStoreTrans];
    [noteStorePort autorelease];
    EDAMNoteStoreClient *noteStore =
    [[EDAMNoteStoreClient alloc] initWithProtocol:noteStorePort];
    [noteStore autorelease];

    // ノートを列挙する
    NSArray *notebooks = [noteStore listNotebooks:authToken];
    EDAMNotebook *defaultNotebook = [notebooks objectAtIndex:0];
    for (EDAMNotebook *notebook in notebooks) {
        NSLog(@"Notebook: %@" ,[notebook name]);
        EDAMNoteFilter *filter = [[EDAMNoteFilter alloc]init];
        [filter setNotebookGuid:[notebook guid]];
        EDAMNoteList *noteList =
        [noteStore findNotes:authToken :filter :0 :100];
        NSArray *notes = [noteList notes];

        for (EDAMNote *note in notes) {
            NSLog(@" * %@",[note title]);
        }
        if ([notebook defaultNotebook]) {
            defaultNotebook = notebook;
        }
    }

    // 送信するノートを生成する
    EDAMResource *resource = [[EDAMResource alloc]init];
    [resource autorelease];
    [resource setData:[self readFileAsData:path]];
    [resource setMime:mime];//@"image/png"];
    EDAMNote *note = [[EDAMNote alloc]init];
    [note setTitle:@"Test note from EDAMDemo"];
    [note setCreated:[[NSDate date]timeIntervalSince1970]*1000];
    [note setUpdated:[[NSDate date]timeIntervalSince1970]*1000];
    [note setActive:YES];
    [note setNotebookGuid:[defaultNotebook guid]];
    //note.addToResources(resource);
    NSMutableArray *newResources = [[NSMutableArray alloc]
                                    initWithArray:[note resources]];
    [newResources autorelease];
    [newResources addObject:resource];
    [note setResources:newResources];
    NSString *hashHex = [self dataToHex:[[resource data] bodyHash]];
    NSString *contents[] = {@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        @"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">",
        @"<en-note>Here's the Evernote logo:<br/>",
        [NSString stringWithFormat:@"<en-media type=\"%@\" hash=\"%@\"/>",
         mime,hashHex],
        @"</en-note>"
    };
    NSString *content =
    [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n",contents[0]
     ,contents[1],contents[2],contents[3],contents[4]];
    [note setContent:content];

    //送信する
    EDAMNote *createdNote = [noteStore createNote:authToken :note];
    NSLog(@"Note created. GUID:%@",[createdNote guid]);

    return YES;
}
@end