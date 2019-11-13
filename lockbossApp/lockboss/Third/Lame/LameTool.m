//
//  LameTool.m
//  RecordVoiceDemo
//
//  Created by allison on 2018/9/1.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "LameTool.h"
#import "lame.h"

@implementation LameTool

+ (NSString *)audioToMP3:(NSString *)sourcePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:sourcePath]) {
        NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
        @try {
            int read, write;
            
            FILE *pcm = fopen([sourcePath cStringUsingEncoding:1], "rb");
            fseek(pcm, 4*1024, SEEK_CUR);
            FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                size_t size = (size_t)(2*sizeof(short int));
                read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
                if (read == 0) {
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                } else {
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                }
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return outPath;
        }
    }
}

@end
