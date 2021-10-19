#ifndef GO_BOARD_H_INCLUDED
#define GO_BOARD_H_INCLUDED


//�������19������21ԭ��������������Χ������ʹ�ã����鲻Խ�磩
#define MAX_BOARDSIZE 21
//��Ծ�411�֣�Ϊ����ʹ��������Ϣ�������±�0δʹ��
#define MAX_STONENUMBER 412

//����
typedef enum tag_BOOL
{
    false,
    true
} bool;

//���̽�������ӷ���
typedef enum tag_Direction
{
    SIDE_NONE  = 0,
    SIDE_LEFT  = 1,      //������ 0001
    SIDE_RIGHT = 2,      //������ 0010
    SIDE_UP    = 4,      //������ 0100
    SIDE_DOWN  = 8,      //������ 1000
    SIDE_ALL   = 15      //������ 1111
} DIRECTION;
//�ж�״̬ a ���Ƿ�����ض�ֵ b
#define HaveThisState(a, b) ((a & b) == b)
//�ж�״̬ a ���Ƿ񲻰����ض�ֵ b
#define NoThisState(a, b) ((a & b) != b)

//������ɫ
typedef enum tag_StoneColor
{
    GREY = -1,     //������Χ
    EMPTY,         //����
    BLACK,         //��ɫ
    WHITE          //��ɫ
} STONECOLOR;
//��ɫ���ڱ�ף��ױ��
#define OtherColor(c) (BLACK + WHITE - c)

//������ÿһ��������״̬
typedef struct tagBoardData
{
    STONECOLOR c;  //��λ������ɫ
    int n;         //��λ����������0 ���ӣ�1-n ����
} BOARDDATA;
//����������ֽ�
#define MAKESITE(x, y) (x*MAX_BOARDSIZE+y)
#define XPOINT(p) (p/MAX_BOARDSIZE)
#define YPOINT(p) (p%MAX_BOARDSIZE)

//ÿһ�����ӵ���Ϣ
typedef struct tagStoneData
{
    unsigned char x;         //����
    unsigned char y;
    STONECOLOR c;  //��ɫ
    int n;         //����
    int sn;        //��ʾ������0 ���ӻ�̶��ӣ�1-n ��ʾ��������
    int ko;        //������
    int bk;        //��������
} STONEDATA;


extern int g_iBoardSize;                                   //��������
extern BOARDDATA g_BoardData[MAX_BOARDSIZE*MAX_BOARDSIZE];//����״̬����

extern int g_iStoneNumber, g_iShowStoneNumber;             //����������������ʾ��
extern STONECOLOR g_cNextColor;                            //��һ�������ɫ
extern STONEDATA g_StoneData[MAX_STONENUMBER];             //������Ϣ����

extern int g_iBackStoneNumber;               			   //���ӱ���������
extern STONEDATA g_BackStoneData[MAX_STONENUMBER];         //����������Ϣ����

extern int g_iTempStoneNumber;               			   //��ʱ���ӱ���������

extern STONECOLOR g_BoardExam0[MAX_BOARDSIZE*MAX_BOARDSIZE];//��Ŀ״̬���������ʵ������ɫ
extern STONECOLOR g_BoardExam2[MAX_BOARDSIZE*MAX_BOARDSIZE];//��Ŀ״̬�������������ɫ


//��������״̬��������Ϣ�����ã����ʱһ��Ҫע�⣺
//���������״̬���ݣ�����������Ϣ����
extern void ClearBoardData(void);                  			   //������̽����״̬����
extern void ClearStoneData(void);                              //���������Ϣ����
extern void CopyStoneData(void);				           //����������Ϣ����

extern void InitBoardExam0(void);                              //��Ŀ״̬���ݳ�ʼ��
extern void InvertBoardExam0(unsigned char, unsigned char);//�ı��Ŀ״̬���������ʵ������ɫ
extern void ScanBoardExam(int *, int *, int *);            //ȫ��ɨ�裬ȡ�úڰ׸�ɫ����

extern int GetLiberty(unsigned char, unsigned char, STONECOLOR);     //�������̽���������ӵ�����

extern int PlayStone(unsigned char, unsigned char, STONECOLOR, bool);//����һ����
extern bool WithdrawOneStep(void);                                   //����һ��


#endif // GO_BOARD_H_INCLUDED
