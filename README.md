# IOPaint RESTful API 接口文档

当启动 IOPaint 服务时，它会通过 FastAPI 提供一系列 RESTful API 接口，用于图像处理和管理。

## 启动服务

```bash
iopaint start --model=lama --device=cpu --port=8080
```

服务启动后，可以通过 `http://localhost:8080` 访问 API 接口。

## API 接口列表

### 1. 获取服务器配置信息

**接口地址**: `GET /api/v1/server-config`

**接口说明**: 获取服务器当前的配置信息，包括插件信息、模型信息、设备设置等。

**返回参数**:
- `plugins`: 插件列表
  - `name`: 插件名称
  - `support_gen_image`: 是否支持生成图像
  - `support_gen_mask`: 是否支持生成遮罩
- `modelInfos`: 可用模型列表
  - `name`: 模型名称
  - `path`: 模型路径
  - `model_type`: 模型类型
  - `is_single_file_diffusers`: 是否为单文件diffusers模型
- `removeBGModel`: 当前移除背景模型
- `removeBGModels`: 可用的移除背景模型列表
- `realesrganModel`: 当前超分辨率模型
- `realesrganModels`: 可用的超分辨率模型列表
- `interactiveSegModel`: 当前交互式分割模型
- `interactiveSegModels`: 可用的交互式分割模型列表
- `enableFileManager`: 是否启用文件管理器
- `enableAutoSaving`: 是否启用自动保存
- `enableControlnet`: 是否启用ControlNet
- `controlnetMethod`: ControlNet方法
- `disableModelSwitch`: 是否禁用模型切换
- `isDesktop`: 是否为桌面应用
- `samplers`: 可用的采样器列表

### 2. 获取当前模型信息

**接口地址**: `GET /api/v1/model`

**接口说明**: 获取当前正在使用的模型信息。

**返回参数**:
- `name`: 模型名称
- `path`: 模型路径
- `model_type`: 模型类型
- `is_single_file_diffusers`: 是否为单文件diffusers模型

### 3. 切换模型

**接口地址**: `POST /api/v1/model`

**接口说明**: 切换到指定的模型。

**请求参数**:
- `name`: 要切换到的模型名称

**返回参数**:
- `name`: 模型名称
- `path`: 模型路径
- `model_type`: 模型类型
- `is_single_file_diffusers`: 是否为单文件diffusers模型

### 4. 获取输入图像

**接口地址**: `GET /api/v1/inputimage`

**接口说明**: 获取当前输入的图像文件。

### 5. 图像修复处理

**接口地址**: `POST /api/v1/inpaint`

**接口说明**: 对图像进行修复处理。

**请求参数** (InpaintRequest):
- `image`: base64编码的图像数据
- `mask`: base64编码的遮罩数据
- `ldm_steps`: LDM模型的步数，默认为20
- `ldm_sampler`: LDM模型的采样器，默认为"plms"
- `zits_wireframe`: 是否为zits模型启用线框，默认为True
- `hd_strategy`: 高清策略，可选值为"Original"、"Resize"、"Crop"，默认为"Crop"
- `hd_strategy_crop_trigger_size`: 触发裁剪策略的尺寸阈值，默认为800
- `hd_strategy_crop_margin`: 裁剪边距，默认为128
- `hd_strategy_resize_limit`: 调整大小限制，默认为1280
- `prompt`: 扩散模型提示词
- `negative_prompt`: 扩散模型负面提示词
- `use_croper`: 是否在扩散修复前裁剪图像，默认为False
- `croper_x`: 裁剪起始点x坐标
- `croper_y`: 裁剪起始点y坐标
- `croper_height`: 裁剪高度
- `croper_width`: 裁剪宽度
- `use_extender`: 是否在SD外绘前扩展图像，默认为False
- `extender_x`: 扩展起始点x坐标
- `extender_y`: 扩展起始点y坐标
- `extender_height`: 扩展高度
- `extender_width`: 扩展宽度
- `sd_scale`: SD修复前调整图像大小的比例，范围(0.0, 1.0]，默认为1.0
- `sd_mask_blur`: 遮罩边缘模糊程度，默认为11
- `sd_strength`: 添加到基础图像的噪声强度，范围[0.0, 1.0]，默认为1.0
- `sd_steps`: 去噪步骤数，默认为50
- `sd_guidance_scale`: 指导比例，默认为7.5
- `sd_sampler`: 扩散模型采样器，默认为"UniPC"
- `sd_seed`: 扩散模型种子，默认为42
- `sd_match_histograms`: 是否匹配直方图，默认为False
- `sd_outpainting_softness`: 外绘柔和度，默认为20.0
- `sd_outpainting_space`: 外绘间距，默认为20.0
- `sd_lcm_lora`: 是否启用LCM-LoRA模式，默认为False
- `sd_keep_unmasked_area`: 是否保持未遮罩区域不变，默认为True
- `cv2_flag`: OpenCV修复标志，默认为"INPAINT_NS"
- `cv2_radius`: OpenCV修复半径，默认为4
- `paint_by_example_example_image`: Paint by Example模型的示例图像(base64编码)
- `p2p_image_guidance_scale`: 图像指导比例，默认为1.5
- `enable_controlnet`: 是否启用ControlNet，默认为False
- `controlnet_conditioning_scale`: ControlNet条件缩放比例，范围[0.0, 1.0]，默认为0.4
- `controlnet_method`: ControlNet方法，默认为"lllyasviel/control_v11p_sd15_canny"
- `enable_brushnet`: 是否启用BrushNet，默认为False
- `brushnet_method`: BrushNet方法
- `brushnet_conditioning_scale`: BrushNet条件缩放比例，范围[0.0, 1.0]，默认为1.0
- `enable_powerpaint_v2`: 是否启用PowerPaint v2，默认为False
- `powerpaint_task`: PowerPaint任务类型
- `fitting_degree`: 控制生成对象与遮罩形状拟合程度，范围(0.0, 1.0]，默认为1.0

### 6. 切换插件模型

**接口地址**: `POST /api/v1/switch_plugin_model`

**接口说明**: 切换指定插件的模型。

**请求参数** (SwitchPluginModelRequest):
- `plugin_name`: 插件名称
- `model_name`: 要切换到的模型名称

### 7. 运行插件生成遮罩

**接口地址**: `POST /api/v1/run_plugin_gen_mask`

**接口说明**: 使用指定插件生成遮罩。

**请求参数** (RunPluginRequest):
- `name`: 插件名称
- `image`: base64编码的图像数据
- `clicks`: 交互式分割的点击坐标，格式为[[x,y,0/1], [x2,y2,0/1]]
- `scale`: 超分辨率的缩放比例，默认为2.0

### 8. 运行插件生成图像

**接口地址**: `POST /api/v1/run_plugin_gen_image`

**接口说明**: 使用指定插件生成图像。

**请求参数** (RunPluginRequest):
- `name`: 插件名称
- `image`: base64编码的图像数据
- `clicks`: 交互式分割的点击坐标，格式为[[x,y,0/1], [x2,y2,0/1]]
- `scale`: 超分辨率的缩放比例，默认为2.0

### 9. 获取采样器列表

**接口地址**: `GET /api/v1/samplers`

**接口说明**: 获取可用的采样器列表。

### 10. 调整遮罩

**接口地址**: `POST /api/v1/adjust_mask`

**接口说明**: 对遮罩进行调整操作。

**请求参数** (AdjustMaskRequest):
- `mask`: base64编码的遮罩数据
- `operate`: 操作类型，可选值为"expand"(扩展)、"shrink"(收缩)、"reverse"(反转)
- `kernel_size`: 扩展遮罩的内核大小，默认为5

### 11. 保存图像

**接口地址**: `POST /api/v1/save_image`

**接口说明**: 将图像保存到输出目录。

**请求参数**:
- 文件上传形式，包含要保存的图像文件

### 12. 获取图像信息

**接口地址**: `POST /api/v1/gen-info`

**接口说明**: 从图像文件中提取生成信息。

**请求参数**:
- 文件上传形式，包含要分析的图像文件

**返回参数** (GenInfoResponse):
- `prompt`: 提示词
- `negative_prompt`: 负面提示词