<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IDCDesign 项目交付清单打包工具</title>
    <!-- 换用国内最稳定的七牛云 Staticfile 节点 -->
    <script src="https://cdn.staticfile.org/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.staticfile.org/FileSaver.js/2.0.5/FileSaver.min.js"></script>
    
    <style>
        :root {
            --primary-color: #333333;
            --bg-color: #F4F7F9;
            --text-color: #1A1A1A;
            --border-color: #E0E0E0;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            line-height: 1.6;
            padding: 40px 20px;
            margin: 0;
        }
        .container {
            max-width: 850px;
            margin: 0 auto;
            background: #ffffff;
            padding: 40px 50px;
            border-radius: 6px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .header { margin-bottom: 30px; }
        .header h1 {
            color: var(--primary-color);
            margin: 0 0 10px 0;
            font-size: 26px;
            font-weight: 600;
        }
        .intro-text {
            color: #666; font-size: 14px; background: #f9f9f9;
            padding: 12px 15px; border-left: 4px solid #FF0005;
            border-radius: 0 4px 4px 0;
        }
        .section-title {
            font-size: 20px; font-weight: 600; margin-top: 40px; margin-bottom: 20px;
            color: var(--primary-color); display: flex; align-items: center;
        }
        .section-title::before {
            content: ""; display: inline-block; width: 5px; height: 18px;
            background-color: #FF0005; margin-right: 10px; border-radius: 2px;
        }
        .question-block {
            margin-bottom: 25px; background: #fff;
            border: 1px solid var(--border-color); border-radius: 6px; padding: 20px;
        }
        .question-title {
            font-size: 16px; font-weight: 600; margin-bottom: 12px; color: #000;
        }
        /* 规范指南面板样式 */
        .guide-box {
            background-color: #F8F9FA; border: 1px solid #E9ECEF;
            border-radius: 4px; padding: 12px 15px; margin-bottom: 20px;
            font-size: 13px; color: #555;
        }
        .guide-box p { margin: 0 0 5px 0; }
        .guide-box strong { color: #333; }
        .guide-tag {
            display: inline-block; background: #E2E3E5; padding: 2px 6px;
            border-radius: 3px; font-family: monospace; color: #D9230F; font-size: 12px;
        }
        
        .upload-row {
            display: flex; align-items: center; margin-bottom: 12px; padding-left: 5px;
        }
        .upload-label-text {
            width: 200px; font-size: 14px; color: #444; display: flex; align-items: center;
        }
        .upload-label-text::before {
            content: "└"; color: #ccc; margin-right: 8px; font-family: monospace;
        }
        .upload-btn {
            display: inline-block; background-color: #f0f0f0; border: 1px solid #ccc;
            padding: 4px 15px; border-radius: 4px; cursor: pointer; font-size: 13px;
            color: #333; transition: all 0.2s;
        }
        .upload-btn:hover { background-color: #e4e4e4; border-color: #bbb; }
        .upload-btn input[type="file"] { display: none; }
        .file-name-display {
            font-size: 13px; color: #FF0005; margin-left: 15px;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 280px;
        }
        
        .submit-btn {
            display: block; width: 100%; padding: 16px; background-color: #333;
            color: #fff; border: none; border-radius: 6px; font-size: 18px;
            font-weight: 600; cursor: pointer; transition: background 0.3s;
            margin-top: 40px; letter-spacing: 1px;
        }
        .submit-btn:hover { background-color: #FF0005; }
        .submit-btn:disabled { background-color: #999; cursor: not-allowed; }
        
        .base-info { display: flex; gap: 20px; margin-bottom: 20px; }
        .base-info input {
            flex: 1; padding: 10px 15px; border: 1px solid var(--border-color);
            border-radius: 4px; font-size: 14px; outline: none;
        }
        .base-info input:focus { border-color: #FF0005; }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <svg style="height: 45px; width: auto; margin-bottom: 25px; display: block;" viewBox="0 0 341 157" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M31.6255 156.624L53.6274 0.0101529H22.0018L0 156.624H31.6255ZM217.529 70.4795L227.419 0.0101529H195.826L192.607 22.8247C171.236 1.50456 139.478 -5.60216 111.038 4.59299C82.6313 14.7881 62.5874 40.4254 59.5675 70.4795H91.1599C94.9762 47.8642 114.555 31.3262 137.453 31.3262C160.351 31.3262 179.93 47.8642 183.747 70.4795H217.563H217.529ZM340.481 70.4795C338.191 47.6982 326.078 27.1086 307.295 14.0243C288.546 0.973212 265.017 -3.24432 242.883 2.53403L237.839 38.3997C251.146 30.1307 267.672 29.0348 281.909 35.4773C296.178 41.8866 306.3 55.0374 308.922 70.4795H340.481ZM340.481 86.1541C337.527 115.411 318.512 140.517 291.167 151.244C263.856 161.97 232.795 156.457 210.793 136.997C217.662 128.429 222.972 118.666 226.456 108.271C238.171 122.418 257.053 128.462 274.774 123.713C292.528 118.965 305.868 104.286 308.955 86.1541H340.514H340.481ZM215.273 86.1541H183.714C179.897 108.769 160.318 125.307 137.42 125.307C114.522 125.307 94.943 108.769 91.1267 86.1541H59.5344C63.583 126.171 97.2328 156.624 137.42 156.624C177.607 156.624 211.257 126.171 215.273 86.1541Z" fill="#FF0005"/>
        </svg>
        <h1>IDCDesign 交付物整理归档系统</h1>
        <div class="intro-text">
            <strong>内部须知：</strong>请在各阶段下方上传对应文件。<strong>无需全部填满也能导出</strong>，缺失项在报告中会自动标记为“未提供”。打包过程在本地完成，速度极快。
        </div>
    </div>

    <form id="surveyForm">
        <div class="base-info">
            <input type="text" name="项目名称" placeholder="* 必填：请输入项目名称 (如: 智能音箱外观设计)" required>
            <input type="text" name="负责人" placeholder="* 必填：请输入交付整理人姓名" required>
        </div>

        <div class="section-title">一、外观造型设计</div>

        <!-- 1. 外观设计效果图 -->
        <div class="question-block">
            <div class="question-title">1. 外观设计效果图</div>
            <div class="guide-box">
                <p><strong>📝 简介：</strong>呈现产品外观材质、色彩与光影的最终渲染输出图。</p>
                <p><strong>🏷️ 命名建议：</strong><span class="guide-tag">项目名_方案A_主视角_01.jpg</span></p>
                <p><strong>💡 格式规范：</strong>建议提供 JPG/PNG 格式，分辨率不低于 1920x1080，无压缩过曝。</p>
            </div>
            
            <div class="upload-row">
                <div class="upload-label-text">方案 A (可选)</div>
                <label class="upload-btn"><input type="file" id="renderA" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
            <div class="upload-row">
                <div class="upload-label-text">方案 B (可选)</div>
                <label class="upload-btn"><input type="file" id="renderB" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
            <div class="upload-row">
                <div class="upload-label-text">方案 C (可选)</div>
                <label class="upload-btn"><input type="file" id="renderC" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
        </div>

        <!-- 2. 外观设计提交PPT -->
        <div class="question-block">
            <div class="question-title">2. 外观设计提交PPT</div>
            <div class="guide-box">
                <p><strong>📝 简介：</strong>向客户汇报的演示文稿，需包含主视角、细节展示、场景图、配色方案及尺寸图。</p>
                <p><strong>🏷️ 命名建议：</strong><span class="guide-tag">项目名_外观提案_方案A_V1.0.pptx</span></p>
                <p><strong>💡 格式规范：</strong>同时提供 PPTX 源文件与 PDF 导出件，16:9 画幅，确保字体无丢失。</p>
            </div>
            
            <div class="upload-row">
                <div class="upload-label-text">方案 A 演示文档 (可选)</div>
                <label class="upload-btn"><input type="file" id="pptA" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
            <div class="upload-row">
                <div class="upload-label-text">方案 B 演示文档 (可选)</div>
                <label class="upload-btn"><input type="file" id="pptB" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
            <div class="upload-row">
                <div class="upload-label-text">方案 C 演示文档 (可选)</div>
                <label class="upload-btn"><input type="file" id="pptC" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
        </div>

        <!-- 3. 外观设计3D文件 -->
        <div class="question-block">
            <div class="question-title">3. 外观设计 3D 文件</div>
            <div class="guide-box">
                <p><strong>📝 简介：</strong>工业设计阶段建立的三维数模文件，是后续结构设计的基础。</p>
                <p><strong>🏷️ 命名建议：</strong><span class="guide-tag">项目名_3D_犀牛源文件_V1.0.3dm</span></p>
                <p><strong>💡 格式规范：</strong>3dm 源文件需整理图层且命名清晰；STP 文件需确保实体闭合、无严重破面。</p>
            </div>
            
            <div class="upload-row">
                <div class="upload-label-text">外观犀牛源文件 (可选)</div>
                <label class="upload-btn"><input type="file" id="rhino3d" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
            <div class="upload-row">
                <div class="upload-label-text">STP 通用文件 (可选)</div>
                <label class="upload-btn"><input type="file" id="stp3d" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
        </div>

        <!-- 4. 工艺文档 -->
        <div class="question-block">
            <div class="question-title">4. 工艺文档 (CMF)</div>
            <div class="guide-box">
                <p><strong>📝 简介：</strong>定义产品表面处理（工艺）、色彩（潘通色号）及材质的说明规范。</p>
                <p><strong>🏷️ 命名建议：</strong><span class="guide-tag">项目名_CMF工艺规范_V1.0.pdf</span></p>
                <p><strong>💡 格式规范：</strong>提供清晰标注的 PDF 或 Excel 文件，色号与打样标准需明确。</p>
            </div>
            
            <div class="upload-row">
                <div class="upload-label-text">工艺规范文档 (可选)</div>
                <label class="upload-btn"><input type="file" id="craftDoc" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
        </div>

        <!-- 5. 丝印文档 -->
        <div class="question-block">
            <div class="question-title">5. 丝印文档</div>
            <div class="guide-box">
                <p><strong>📝 简介：</strong>用于产品外壳表面的 Logo、按键图示、说明文字等矢量丝印文件。</p>
                <p><strong>🏷️ 命名建议：</strong><span class="guide-tag">项目名_丝印图纸_V1.0.cdr</span></p>
                <p><strong>💡 格式规范：</strong>所有文字必须【转曲】！CDR 文件建议另存为低版本（如 X4），并附带等比例 PDF。</p>
            </div>
            
            <div class="upload-row">
                <div class="upload-label-text">CDR 源文件 (可选)</div>
                <label class="upload-btn"><input type="file" id="silkCdr" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
            <div class="upload-row">
                <div class="upload-label-text">PDF 可移植文件 (可选)</div>
                <label class="upload-btn"><input type="file" id="silkPdf" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
        </div>

        <!-- 6. 专利申请文件 -->
        <div class="question-block">
            <div class="question-title">6. 专利申请文件</div>
            <div class="guide-box">
                <p><strong>📝 简介：</strong>用于企业申请外观专利的标准图纸（六视图 + 立体透视图）。</p>
                <p><strong>🏷️ 命名建议：</strong><span class="guide-tag">项目名_外观专利_六视图.pdf</span></p>
                <p><strong>💡 格式规范：</strong>必须为纯白背景，无透视畸变的纯线框图或灰度图，多视角需严格对齐。</p>
            </div>
            
            <div class="upload-row">
                <div class="upload-label-text">六视图 + 透视图 (可选)</div>
                <label class="upload-btn"><input type="file" id="patentViews" multiple onchange="updateFileName(this)">上传文件</label>
                <span class="file-name-display"></span>
            </div>
        </div>

        <button type="submit" id="submitBtn" class="submit-btn">📁 一键生成标准交付归档包 (.zip)</button>
        <div style="text-align: center; font-size: 13px; color: #999; margin-top: 15px;">
            无论上传多少文件均可随时打包。<br>系统将在本地生成带日期后缀的 ZIP 包，大文件打包可能需要几秒钟，请勿关闭页面。
        </div>
    </form>
</div>

<script>
    // 界面显示：更新文件名称
    function updateFileName(input) {
        const displaySpan = input.parentElement.nextElementSibling;
        if (input.files && input.files.length > 0) {
            if (input.files.length === 1) {
                displaySpan.textContent = input.files[0].name;
                displaySpan.style.color = '#333';
            } else {
                displaySpan.textContent = `[已选 ${input.files.length} 个文件]`;
                displaySpan.style.color = '#FF0005';
            }
        } else {
            displaySpan.textContent = '';
        }
    }

    // 后台逻辑：将文件加入 ZIP 
    function addFilesToZip(inputId, folderPath, zipInstance) {
        const files = document.getElementById(inputId).files;
        if (files && files.length > 0) {
            const folder = zipInstance.folder(folderPath);
            let fileNames = [];
            for (let i = 0; i < files.length; i++) {
                folder.file(files[i].name, files[i]);
                fileNames.push(files[i].name);
            }
            return `<span style="color: green;">✔ 已归档 (${files.length} 个文件)</span>`;
        }
        return `<span style="color: #999;">- 未提供 -</span>`;
    }

    // 获取格式化时间字符串 YYYYMMDD_HHmm
    function getFormattedTime() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        return `${year}${month}${day}_${hours}${minutes}`;
    }

    document.getElementById('surveyForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        // 【核心防御】：检测打包插件是否成功加载
        if (typeof JSZip === 'undefined') {
            alert("⚠️ 核心组件加载失败！\n\n原因：您的网络或浏览器的广告拦截插件(AdBlock)拦截了底层的运行脚本。\n\n解决办法：请刷新页面，或关闭网页广告拦截器后重试。");
            return;
        }

        const btn = document.getElementById('submitBtn');
        btn.innerText = '正在执行大文件打包，请稍候...';
        btn.disabled = true;

        try {
            const zip = new JSZip();
            const formData = new FormData(e.target);
            const projectName = formData.get('项目名称').trim() || '未命名项目';
            const author = formData.get('负责人').trim() || '未知';
            
            // 抓取当前时间用于文件名
            const timeStr = getFormattedTime();
            const displayDate = new Date().toLocaleString();

            // 抓取文件并建立标准目录
            const status_renderA = addFilesToZip('renderA', '1_外观设计效果图/方案A', zip);
            const status_renderB = addFilesToZip('renderB', '1_外观设计效果图/方案B', zip);
            const status_renderC = addFilesToZip('renderC', '1_外观设计效果图/方案C', zip);

            const status_pptA = addFilesToZip('pptA', '2_外观设计提交PPT/方案A', zip);
            const status_pptB = addFilesToZip('pptB', '2_外观设计提交PPT/方案B', zip);
            const status_pptC = addFilesToZip('pptC', '2_外观设计提交PPT/方案C', zip);

            const status_rhino = addFilesToZip('rhino3d', '3_外观设计3D文件/犀牛源文件', zip);
            const status_stp = addFilesToZip('stp3d', '3_外观设计3D文件/STP通用文件', zip);

            const status_craft = addFilesToZip('craftDoc', '4_工艺文档', zip);

            const status_silkCdr = addFilesToZip('silkCdr', '5_丝印文档/CDR源文件', zip);
            const status_silkPdf = addFilesToZip('silkPdf', '5_丝印文档/PDF文件', zip);

            const status_patent = addFilesToZip('patentViews', '6_专利申请文件', zip);

            // 构建清单明细 HTML
            let reportHTML = `
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>${projectName} - 交付清单核对表</title>
                <style>
                    body { font-family: -apple-system, "Segoe UI", sans-serif; line-height: 1.6; color: #333; padding: 40px; max-width: 800px; margin: 0 auto; background: #fff;}
                    h2 { color: #111; border-bottom: 2px solid #FF0005; padding-bottom: 10px; margin-bottom: 5px;}
                    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                    th, td { border: 1px solid #ddd; padding: 12px; text-align: left; font-size: 14px;}
                    th { background-color: #f4f7f9; color: #333; font-weight: 600; width: 40%;}
                    .section-head { background-color: #333; color: #fff; font-weight: bold; text-align: center; font-size: 16px;}
                </style>
            </head>
            <body>
                <h2>IDCDesign 工业设计交付核对清单</h2>
                <div style="margin-bottom: 30px; font-size: 14px; color: #666;">
                    <strong>项目名称：</strong>${projectName}<br>
                    <strong>交付整理人：</strong>${author}<br>
                    <strong>打包时间：</strong>${displayDate}
                </div>

                <table>
                    <tr><td colspan="2" class="section-head">一、外观造型设计</td></tr>
                    
                    <tr><th colspan="2" style="background:#eee;">1. 外观设计效果图</th></tr>
                    <tr><td>方案 A</td><td>${status_renderA}</td></tr>
                    <tr><td>方案 B</td><td>${status_renderB}</td></tr>
                    <tr><td>方案 C</td><td>${status_renderC}</td></tr>

                    <tr><th colspan="2" style="background:#eee;">2. 外观设计提交PPT</th></tr>
                    <tr><td>方案 A 演示文档</td><td>${status_pptA}</td></tr>
                    <tr><td>方案 B 演示文档</td><td>${status_pptB}</td></tr>
                    <tr><td>方案 C 演示文档</td><td>${status_pptC}</td></tr>

                    <tr><th colspan="2" style="background:#eee;">3. 外观设计3D文件</th></tr>
                    <tr><td>外观犀牛源文件</td><td>${status_rhino}</td></tr>
                    <tr><td>STP 通用文件</td><td>${status_stp}</td></tr>

                    <tr><th colspan="2" style="background:#eee;">4. 工艺文档</th></tr>
                    <tr><td>工艺规范文档 (CMF)</td><td>${status_craft}</td></tr>

                    <tr><th colspan="2" style="background:#eee;">5. 丝印文档</th></tr>
                    <tr><td>CDR 源文件</td><td>${status_silkCdr}</td></tr>
                    <tr><td>PDF 可移植文件</td><td>${status_silkPdf}</td></tr>

                    <tr><th colspan="2" style="background:#eee;">6. 专利申请文件</th></tr>
                    <tr><td>六视图 + 透视图</td><td>${status_patent}</td></tr>
                </table>
            </body>
            </html>
            `;

            zip.file(`IDCDesign_项目交付核对单_${projectName}.html`, reportHTML);

            // 加入 compression: "STORE"，不对大文件进行深度压缩计算
            const zipContent = await zip.generateAsync({ 
                type: "blob",
                compression: "STORE" 
            });
            
            // 导出命名：项目名称_当前时间.zip
            saveAs(zipContent, `${projectName}_${timeStr}.zip`);

            btn.innerText = '打包完成！文件已下载至本地';
            setTimeout(() => {
                btn.innerText = '📁 一键生成标准交付归档包 (.zip)';
                btn.disabled = false;
            }, 3000);

        } catch (error) {
            console.error("打包详细错误信息:", error);
            alert("打包中断！\n\n原因可能是：\n1. 上传的某个 3D/PPT 文件体积过大，超出了浏览器运行内存。\n2. 请尝试分批次打包，或刷新页面重试。\n\n技术错误代码：" + error.message);
            btn.innerText = '📁 一键生成标准交付归档包 (.zip)';
            btn.disabled = false;
        }
    });
</script>

</body>
</html>
