# -*- coding: utf-8 -*-
"""使用 Pillow 生成原型图和流程图 PNG"""
import os
from PIL import Image, ImageDraw, ImageFont

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROTO_DIR = os.path.join(BASE, 'docs', '03-原型图')
FLOW_DIR = os.path.join(BASE, 'docs', '03-流程图')
DOCS_DIR = os.path.join(BASE, 'docs')

for d in [PROTO_DIR, FLOW_DIR, DOCS_DIR]:
    os.makedirs(d, exist_ok=True)

try:
    FONT = ImageFont.truetype('msyh.ttc', 16)
    FONT_SM = ImageFont.truetype('msyh.ttc', 14)
    FONT_LG = ImageFont.truetype('msyh.ttc', 20)
    FONT_TITLE = ImageFont.truetype('msyh.ttc', 24)
except Exception:
    FONT = ImageFont.load_default()
    FONT_SM = FONT
    FONT_LG = FONT
    FONT_TITLE = FONT

BLUE = '#409EFF'
DARK = '#304156'
GRAY = '#909399'
LIGHT = '#f0f2f5'
WHITE = '#ffffff'


def draw_header(draw, w, title, user=''):
    draw.rectangle([0, 0, w, 56], fill=BLUE)
    draw.text((24, 16), title, fill=WHITE, font=FONT_LG)
    if user:
        draw.text((w - 200, 18), user, fill=WHITE, font=FONT_SM)


def draw_sidebar(draw, items, active=0):
    draw.rectangle([0, 56, 220, 800], fill=DARK)
    for i, item in enumerate(items):
        y = 70 + i * 48
        if i == active:
            draw.rectangle([0, y, 220, y + 44], fill=BLUE)
        draw.text((24, y + 12), item, fill=WHITE if i == active else '#bfcbd9', font=FONT_SM)


def draw_card(draw, x, y, w, h, title=None):
    draw.rectangle([x, y, x + w, y + h], fill=WHITE, outline='#ebeef5')
    if title:
        draw.text((x + 16, y + 16), title, fill='#303133', font=FONT_LG)
        draw.line([x, y + 48, x + w, y + 48], fill='#ebeef5')


def save_desktop(name, draw_fn):
    img = Image.new('RGB', (1280, 800), LIGHT)
    draw = ImageDraw.Draw(img)
    draw_fn(draw, img)
    img.save(os.path.join(PROTO_DIR, name))


def save_mobile(name, draw_fn):
    img = Image.new('RGB', (375, 812), '#f5f5f5')
    draw = ImageDraw.Draw(img)
    draw.rectangle([0, 0, 375, 88], fill=BLUE)
    draw_fn(draw, img)
    img.save(os.path.join(PROTO_DIR, name))


def gen_admin_login():
    def draw(draw, img):
        draw.rectangle([0, 0, 1280, 800], fill='#667eea')
        draw.rectangle([430, 200, 850, 600], fill=WHITE)
        draw.text((520, 260), '东软环保公众监督系统', fill='#303133', font=FONT_TITLE)
        draw.text((560, 300), '系统管理员端 - 登录', fill=GRAY, font=FONT_SM)
        draw.text((460, 360), '管理员账号', fill='#606266', font=FONT_SM)
        draw.rectangle([460, 385, 820, 425], outline='#dcdfe6')
        draw.text((470, 395), 'admin', fill='#303133', font=FONT)
        draw.text((460, 445), '登录密码', fill='#606266', font=FONT_SM)
        draw.rectangle([460, 470, 820, 510], outline='#dcdfe6')
        draw.text((470, 480), '******', fill='#303133', font=FONT)
        draw.rectangle([460, 540, 820, 580], fill=BLUE)
        draw.text((600, 550), '登 录', fill=WHITE, font=FONT)
    save_desktop('系统管理员端-登录.png', draw)


def gen_admin_feedback_list():
    def draw(draw, img):
        draw_header(draw, 1280, '东软环保公众监督系统 - 管理员端', '管理员：admin')
        draw_sidebar(draw, ['反馈列表', '统计看板', '系统设置'], 0)
        draw_card(draw, 244, 80, 1012, 680, '公众监督反馈列表')
        headers = ['ID', '监督员', '网格地址', '预估级别', '状态', '提交时间']
        xs = [260, 320, 420, 620, 760, 880]
        for i, h in enumerate(headers):
            draw.text((xs[i], 130), h, fill=GRAY, font=FONT_SM)
        draw.line([244, 155, 1256, 155], fill='#ebeef5')
        rows = [
            ('1', '张三', '沈阳市和平区南京街网格', '轻度污染', '待指派', '2026-06-08 10:30'),
            ('2', '李四', '大连市中山区人民路网格', '良', '已指派', '2026-06-07 15:20'),
            ('3', '王五', '鞍山市铁东区胜利路网格', '优', '已确认', '2026-06-06 09:15'),
        ]
        for ri, row in enumerate(rows):
            y = 170 + ri * 40
            for ci, val in enumerate(row):
                draw.text((xs[ci], y), val, fill='#303133', font=FONT_SM)
    save_desktop('系统管理员端-反馈列表.png', draw)


def gen_admin_feedback_detail():
    def draw(draw, img):
        draw_header(draw, 1280, '东软环保公众监督系统 - 管理员端', '管理员：admin')
        draw_sidebar(draw, ['反馈列表', '统计看板'], 0)
        draw_card(draw, 244, 80, 1012, 500, '反馈详情 #1')
        fields = [
            ('监督员', '张三'), ('所属区域', '辽宁省 - 沈阳市'),
            ('网格地址', '沈阳市和平区南京街网格'), ('预估AQI级别', '轻度污染'),
            ('反馈描述', '该区域近期空气质量较差，有明显雾霾，建议安排网格员实地检测。'),
            ('提交时间', '2026-06-08 10:30:00'), ('当前状态', '待指派'),
        ]
        for i, (k, v) in enumerate(fields):
            y = 130 + i * 36
            draw.text((260, y), k, fill=GRAY, font=FONT_SM)
            draw.text((380, y), v, fill='#303133', font=FONT_SM)
        draw.rectangle([260, 400, 360, 440], fill=BLUE)
        draw.text((275, 410), '指派网格员', fill=WHITE, font=FONT_SM)
    save_desktop('系统管理员端-反馈详情.png', draw)


def gen_admin_assign():
    def draw(draw, img):
        draw_header(draw, 1280, '东软环保公众监督系统 - 管理员端', '管理员：admin')
        draw_sidebar(draw, ['反馈列表', '统计看板'], 0)
        draw_card(draw, 244, 80, 1012, 400, '指派网格员 - 反馈 #1')
        draw.text((260, 130), '网格地址', fill=GRAY, font=FONT_SM)
        draw.text((380, 130), '沈阳市和平区南京街网格', fill='#303133', font=FONT)
        draw.text((260, 180), '选择网格员', fill=GRAY, font=FONT_SM)
        draw.rectangle([380, 175, 700, 215], outline='#dcdfe6')
        draw.text((390, 185), '李网格 (grid001) - 沈阳市', fill='#303133', font=FONT_SM)
        draw.text((260, 240), '指派备注', fill=GRAY, font=FONT_SM)
        draw.rectangle([380, 235, 700, 295], outline='#dcdfe6')
        draw.text((390, 245), '请尽快前往实地检测AQI数据', fill='#303133', font=FONT_SM)
        draw.rectangle([260, 320, 360, 360], fill=BLUE)
        draw.text((275, 330), '确认指派', fill=WHITE, font=FONT_SM)
    save_desktop('系统管理员端-指派网格员.png', draw)


def gen_mobile_page(name, header, lines):
    def draw(draw, img):
        draw.text((120, 50), header, fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 750], fill=WHITE)
        for i, (label, value) in enumerate(lines):
            y = 120 + i * 50
            if label:
                draw.text((28, y), label, fill=GRAY, font=FONT_SM)
            if value:
                draw.text((28, y + (20 if label else 0)), value, fill='#303133', font=FONT)
        draw.rectangle([28, 680, 347, 730], fill=BLUE)
        draw.text((150, 695), '提交', fill=WHITE, font=FONT)
    save_mobile(name, draw)


def gen_supervisor_register():
    def draw(draw, img):
        draw.text((130, 50), '公众监督员注册', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 550], fill=WHITE)
        fields = ['账号', '姓名', '手机号', '密码', '确认密码']
        for i, f in enumerate(fields):
            y = 120 + i * 70
            draw.text((28, y), f, fill='#606266', font=FONT_SM)
            draw.rectangle([28, y + 22, 347, y + 56], outline='#dcdfe6')
        draw.rectangle([28, 480, 347, 530], fill=BLUE)
        draw.text((150, 495), '注 册', fill=WHITE, font=FONT)
    save_mobile('公众监督员端-注册.png', draw)


def gen_supervisor_login():
    def draw(draw, img):
        draw.text((130, 50), '公众监督员登录', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 350], fill=WHITE)
        draw.text((28, 130), '账号', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 152, 347, 186], outline='#dcdfe6')
        draw.text((38, 158), 'supervisor1', fill='#303133', font=FONT)
        draw.text((28, 210), '密码', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 232, 347, 266], outline='#dcdfe6')
        draw.text((38, 238), '******', fill='#303133', font=FONT)
        draw.rectangle([28, 290, 347, 340], fill=BLUE)
        draw.text((150, 305), '登 录', fill=WHITE, font=FONT)
    save_mobile('公众监督员端-登录.png', draw)


def gen_supervisor_select_grid():
    def draw(draw, img):
        draw.text((120, 50), '选择网格地址', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 600], fill=WHITE)
        draw.text((28, 120), '选择省份', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 142, 347, 176], outline='#dcdfe6')
        draw.text((38, 148), '辽宁省', fill='#303133', font=FONT)
        draw.text((28, 200), '选择城市', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 222, 347, 256], outline='#dcdfe6')
        draw.text((38, 228), '沈阳市', fill='#303133', font=FONT)
        draw.text((28, 280), '选择网格', fill='#606266', font=FONT_SM)
        grids = ['和平区\n南京街', '沈河区\n中街', '铁西区\n兴华街']
        for i, g in enumerate(grids):
            x = 28 + i * 110
            color = BLUE if i == 0 else '#dcdfe6'
            draw.rectangle([x, 310, x + 100, 380], outline=color, width=2)
            for j, line in enumerate(g.split('\n')):
                draw.text((x + 20, 325 + j * 22), line, fill=BLUE if i == 0 else '#303133', font=FONT_SM)
        draw.rectangle([28, 520, 347, 570], fill=BLUE)
        draw.text((110, 535), '下一步：提交反馈', fill=WHITE, font=FONT_SM)
    save_mobile('公众监督员端-选择网格.png', draw)


def gen_supervisor_feedback():
    def draw(draw, img):
        draw.text((110, 50), '提交AQI监督反馈', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 650], fill=WHITE)
        draw.text((28, 120), '网格地址：沈阳市和平区南京街网格', fill='#303133', font=FONT_SM)
        draw.text((28, 170), '预估AQI级别', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 192, 347, 226], outline='#dcdfe6')
        draw.text((38, 198), '轻度污染', fill='#303133', font=FONT)
        draw.text((28, 250), '反馈描述', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 272, 347, 360], outline='#dcdfe6')
        draw.text((38, 280), '该区域近期空气质量较差', fill='#303133', font=FONT_SM)
        draw.text((38, 300), '有明显雾霾，建议安排检测。', fill='#303133', font=FONT_SM)
        draw.rectangle([28, 580, 347, 630], fill=BLUE)
        draw.text((130, 595), '提交反馈', fill=WHITE, font=FONT)
    save_mobile('公众监督员端-提交反馈.png', draw)


def gen_grid_login():
    def draw(draw, img):
        draw.text((140, 50), '网格员登录', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 350], fill=WHITE)
        draw.text((28, 130), '网格员账号', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 152, 347, 186], outline='#dcdfe6')
        draw.text((38, 158), 'grid001', fill='#303133', font=FONT)
        draw.text((28, 210), '密码', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 232, 347, 266], outline='#dcdfe6')
        draw.text((38, 238), '******', fill='#303133', font=FONT)
        draw.rectangle([28, 290, 347, 340], fill=BLUE)
        draw.text((150, 305), '登 录', fill=WHITE, font=FONT)
    save_mobile('网格员端-登录.png', draw)


def gen_grid_assign_list():
    def draw(draw, img):
        draw.text((100, 50), '指派监督信息列表', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 320], fill=WHITE)
        draw.text((28, 120), '南京街网格', fill='#303133', font=FONT)
        draw.text((260, 120), '已指派', fill=BLUE, font=FONT_SM)
        draw.text((28, 150), '监督员：张三 | 预估：轻度污染', fill=GRAY, font=FONT_SM)
        draw.text((28, 175), '该区域近期空气质量较差，有明显雾霾', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 250, 347, 300], fill=BLUE)
        draw.text((120, 265), '确认AQI数据', fill=WHITE, font=FONT)
        draw.rectangle([16, 340, 359, 480], fill=WHITE)
        draw.text((28, 360), '中街网格', fill='#303133', font=FONT)
        draw.text((260, 360), '已确认', fill='#67c23a', font=FONT_SM)
        draw.text((28, 390), '监督员：李四 | 确认AQI：85（良）', fill=GRAY, font=FONT_SM)
    save_mobile('网格员端-指派列表.png', draw)


def gen_grid_confirm():
    def draw(draw, img):
        draw.text((80, 50), '确认指派网格AQI数据', fill=WHITE, font=FONT_LG)
        draw.rectangle([16, 100, 359, 650], fill=WHITE)
        draw.text((28, 120), '网格地址：沈阳市和平区南京街网格', fill='#303133', font=FONT_SM)
        draw.text((28, 160), '监督员反馈：预估轻度污染', fill=GRAY, font=FONT_SM)
        draw.text((28, 210), '实测AQI值', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 232, 347, 266], outline='#dcdfe6')
        draw.text((38, 238), '135', fill='#303133', font=FONT)
        draw.text((28, 290), '确认AQI级别', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 312, 347, 346], outline='#dcdfe6')
        draw.text((38, 318), '轻度污染', fill='#303133', font=FONT)
        draw.text((28, 370), '检测备注', fill='#606266', font=FONT_SM)
        draw.rectangle([28, 392, 347, 460], outline='#dcdfe6')
        draw.text((38, 400), '经实地检测，AQI值为135', fill='#303133', font=FONT_SM)
        draw.rectangle([28, 580, 347, 630], fill=BLUE)
        draw.text((130, 595), '提交确认', fill=WHITE, font=FONT)
    save_mobile('网格员端-确认AQI数据.png', draw)


def draw_flowchart(filename, title, steps):
    w, h = 900, max(400, 80 + len(steps) * 70)
    img = Image.new('RGB', (w, h), WHITE)
    draw = ImageDraw.Draw(img)
    draw.text((w // 2 - 80, 20), title, fill='#303133', font=FONT_LG)
    cx = w // 2
    for i, step in enumerate(steps):
        y = 70 + i * 70
        bw, bh = 280, 44
        bx = cx - bw // 2
        if step in ('开始', '结束'):
            draw.ellipse([bx + 80, y, bx + 200, y + bh], outline=BLUE, width=2)
        else:
            draw.rectangle([bx, y, bx + bw, y + bh], outline=BLUE, width=2)
        tw = len(step) * 14
        draw.text((cx - tw // 2, y + 12), step, fill='#303133', font=FONT_SM)
        if i < len(steps) - 1:
            draw.line([cx, y + bh, cx, y + 70], fill=GRAY, width=2)
            draw.polygon([(cx - 5, y + 65), (cx + 5, y + 65), (cx, y + 70)], fill=GRAY)
    img.save(os.path.join(FLOW_DIR, filename))


def gen_flowcharts():
    draw_flowchart('主业务流程图.png', '主业务流程图', [
        '开始', '公众监督员注册登录', '选择网格提交反馈', '管理员查询反馈',
        '指派网格员', '网格员实地检测确认', '生成统计数据', '可视化大屏', '结束'
    ])
    draw_flowchart('公众反馈流程图.png', '公众反馈流程图', [
        '开始', '登录/注册', '选择省份城市', '选择网格地址',
        '填写预估AQI级别', '填写反馈描述', '提交反馈', '结束'
    ])
    draw_flowchart('网格员确认流程图.png', '网格员确认流程图', [
        '开始', '网格员登录', '查询指派信息', '查看反馈详情',
        '实地检测AQI', '录入实测值', '提交确认', '结束'
    ])
    draw_flowchart('管理员指派流程图.png', '管理员指派流程图', [
        '开始', '管理员登录', '查询反馈列表', '查看反馈详情',
        '选择网格员', '确认指派', '通知网格员', '结束'
    ])
    draw_flowchart('统计看板流程图.png', '统计看板流程图', [
        '开始', '查询AQI实测数据', '按区域日期筛选', '生成统计数据',
        '生成可视化图表', '展示趋势与分布', '生成可视化大屏', '结束'
    ])


def gen_er_diagram():
    w, h = 900, 600
    img = Image.new('RGB', (w, h), WHITE)
    draw = ImageDraw.Draw(img)
    draw.text((350, 20), 'ER 关系图', fill='#303133', font=FONT_LG)
    entities = [
        (50, 80, 'sys_admin', ['id PK', 'admin_code']),
        (300, 80, 'supervisor', ['id PK', 'supervisor_code']),
        (550, 80, 'grid_member', ['id PK', 'member_code']),
        (50, 250, 'grid_province', ['id PK', 'province_name']),
        (300, 250, 'grid_city', ['id PK', 'province_id FK']),
        (550, 250, 'aqi_level', ['id PK', 'level_name']),
        (175, 420, 'supervisor_feedback', ['id PK', 'supervisor_id FK', 'grid_member_id FK']),
        (500, 420, 'aqi_statistics', ['id PK', 'province_id FK', 'stat_date']),
    ]
    for x, y, name, fields in entities:
        draw.rectangle([x, y, x + 180, y + 30 + len(fields) * 22], outline=BLUE, width=2)
        draw.text((x + 10, y + 5), name, fill=BLUE, font=FONT_SM)
        for i, f in enumerate(fields):
            draw.text((x + 10, y + 30 + i * 22), f, fill='#303133', font=FONT_SM)
    draw.line([390, 180, 265, 420], fill=GRAY, width=1)
    draw.line([640, 180, 265, 420], fill=GRAY, width=1)
    draw.line([140, 180, 265, 420], fill=GRAY, width=1)
    img.save(os.path.join(DOCS_DIR, 'er-diagram.png'))
    img.save(os.path.join(FLOW_DIR, 'er-diagram.png'))


if __name__ == '__main__':
    gen_admin_login()
    gen_admin_feedback_list()
    gen_admin_feedback_detail()
    gen_admin_assign()
    gen_supervisor_register()
    gen_supervisor_login()
    gen_supervisor_select_grid()
    gen_supervisor_feedback()
    gen_grid_login()
    gen_grid_assign_list()
    gen_grid_confirm()
    gen_flowcharts()
    gen_er_diagram()
    print('All PNGs generated.')
