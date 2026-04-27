import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Добавили isAdmin (считывает статус из data-map-is-admin-value)
  static values = { isAdmin: Boolean }
  static targets = [ "canvas", "svg", "node", "adminMenu", "modal", "editTitle", "editParent", "editImage", "deleteModal", "createRootModal", "newRootTitle", "newRootImage" ]

  connect() {
    this.isDraggingMap = false; this.draggingNode = null;
    this.startX = 0; this.startY = 0; this.translateX = 0; this.translateY = 0;
    this.scale = 1; 
    this.clickThreshold = 5; this.mouseStartX = 0; this.mouseStartY = 0;
    this.selectedNodeId = null; 
    this.franchiseId = window.location.pathname.split('/').pop();

    this.drawLines()

    this.element.addEventListener('wheel', this.zoom.bind(this), { passive: false })
    this.element.addEventListener('pointerdown', this.startDrag.bind(this))
    window.addEventListener('pointermove', this.drag.bind(this))
    window.addEventListener('pointerup', this.endDrag.bind(this))
    window.addEventListener('pointercancel', this.endDrag.bind(this)) // На случай, если палец соскользнет за экран
  }

  zoom(e) {
    e.preventDefault()
    const scaleFactor = 0.05
    const oldScale = this.scale
    if (e.deltaY < 0) { this.scale += scaleFactor } else { this.scale -= scaleFactor }
    this.scale = Math.min(Math.max(0.3, this.scale), 2.0)
    const rect = this.element.getBoundingClientRect()
    const mouseX = e.clientX - rect.left
    const mouseY = e.clientY - rect.top
    this.translateX = mouseX - ((mouseX - this.translateX) * (this.scale / oldScale))
    this.translateY = mouseY - ((mouseY - this.translateY) * (this.scale / oldScale))
    this.updateTransform()
  }

  updateTransform() {
    this.canvasTarget.style.transform = `translate(${this.translateX}px, ${this.translateY}px) scale(${this.scale})`
  }

  showContextMenu(e) {
    // ВАЖНО: Если это не админ, меню не появится
    if (!this.isAdminValue) return;

    const node = e.target.closest('.map-node')
    if (node) {
      e.preventDefault()
      this.selectedNodeId = node.dataset.id
      this.adminMenuTarget.style.left = `${e.clientX}px`
      this.adminMenuTarget.style.top = `${e.clientY}px`
      this.adminMenuTarget.classList.add('active')
    } else {
      this.hideContextMenu()
    }
  }

  hideContextMenu() { 
    if (this.hasAdminMenuTarget) {
      this.adminMenuTarget.classList.remove('active') 
    }
  }
  stopPropagation(e) { e.stopPropagation() }

  openCreateRootModal(e) {
    e.stopPropagation()
    this.newRootTitleTarget.value = ""; this.newRootImageTarget.value = ""
    this.createRootModalTarget.classList.add('active')
  }
  closeCreateRootModal(e) { if(e) e.stopPropagation(); this.createRootModalTarget.classList.remove('active') }

  executeCreateRoot(e) {
    e.stopPropagation()
    const newTitle = this.newRootTitleTarget.value.trim() || "Новый тайтл"
    const newImageUrl = this.newRootImageTarget.value.trim()
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const centerX = ((window.innerWidth / 2) - this.translateX) / this.scale
    const centerY = ((window.innerHeight / 2) - this.translateY) / this.scale

    fetch('/maps/create_node', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken },
      body: JSON.stringify({ franchise_id: this.franchiseId, parent_id: null, pos_x: centerX, pos_y: centerY, image_url: newImageUrl, title: newTitle })
    })
    .then(response => response.json())
    .then(data => {
      const newNode = document.createElement('div')
      newNode.className = 'map-node'
      newNode.dataset.mapTarget = 'node'
      newNode.dataset.id = data.id
      newNode.dataset.parentId = ""
      newNode.dataset.imageUrl = newImageUrl
      newNode.style.left = `${data.pos_x}px`
      newNode.style.top = `${data.pos_y}px`
      newNode.textContent = data.title
      if (newImageUrl) newNode.style.backgroundImage = `url('${newImageUrl}')`
      this.canvasTarget.appendChild(newNode)
      this.closeCreateRootModal()
    })
  }

  menuEdit(e) {
    e.stopPropagation(); this.hideContextMenu()
    const node = this.nodeTargets.find(n => n.dataset.id === String(this.selectedNodeId))
    if (!node) return
    this.editParentTarget.innerHTML = '<option value="">-- Без связи --</option>'
    this.nodeTargets.forEach(n => {
      if (n.dataset.id !== String(this.selectedNodeId)) {
        const opt = document.createElement('option'); opt.value = n.dataset.id; opt.textContent = n.textContent.trim()
        this.editParentTarget.appendChild(opt)
      }
    })
    this.editTitleTarget.value = node.textContent.trim()
    this.editParentTarget.value = node.dataset.parentId || ""
    this.editImageTarget.value = node.dataset.imageUrl || ""
    this.modalTarget.classList.add('active')
  }

  closeModal(e) { if(e) e.stopPropagation(); this.modalTarget.classList.remove('active') }

  saveNodeInfo(e) {
    e.stopPropagation()
    const newTitle = this.editTitleTarget.value.trim(); const newParentId = this.editParentTarget.value; const newImageUrl = this.editImageTarget.value.trim()
    const nodeId = this.selectedNodeId; const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(`/maps/update_node/${nodeId}`, { method: 'PATCH', headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken }, body: JSON.stringify({ title: newTitle, parent_id: newParentId, image_url: newImageUrl }) })
    .then(response => {
      if(response.ok) {
        const node = this.nodeTargets.find(n => n.dataset.id === String(nodeId))
        if (node) {
          node.textContent = newTitle; node.dataset.parentId = newParentId; node.dataset.imageUrl = newImageUrl
          if (newImageUrl) node.style.backgroundImage = `url('${newImageUrl}')`
          else node.style.backgroundImage = 'none'
          this.drawLines() 
        }
        this.closeModal()
      }
    })
  }

  menuAddChild(e) {
    e.stopPropagation(); const parentId = this.selectedNodeId; this.hideContextMenu()
    const parentNode = this.nodeTargets.find(n => n.dataset.id === String(parentId))
    if (!parentNode) return
    const newX = parseFloat(parentNode.style.left) + 200; const newY = parseFloat(parentNode.style.top) + 50
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch('/maps/create_node', { method: 'POST', headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken }, body: JSON.stringify({ franchise_id: this.franchiseId, parent_id: parentId, pos_x: newX, pos_y: newY, image_url: "" }) })
    .then(response => response.json())
    .then(data => {
      const newNode = document.createElement('div'); newNode.className = 'map-node'; newNode.dataset.mapTarget = 'node'; newNode.dataset.id = data.id; newNode.dataset.parentId = data.parent_id; newNode.dataset.imageUrl = ""
      newNode.style.left = `${data.pos_x}px`; newNode.style.top = `${data.pos_y}px`; newNode.textContent = data.title
      this.canvasTarget.appendChild(newNode); this.drawLines()
    })
  }

  menuDelete(e) { e.stopPropagation(); this.hideContextMenu(); this.deleteModalTarget.classList.add('active') }
  closeDeleteModal(e) { if(e) e.stopPropagation(); this.deleteModalTarget.classList.remove('active') }

  executeDelete(e) {
    e.stopPropagation(); const nodeId = this.selectedNodeId; const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(`/maps/delete_node/${nodeId}`, { method: 'DELETE', headers: { 'X-CSRF-Token': csrfToken } })
    .then(response => {
      if (response.ok) {
        const nodeElement = this.nodeTargets.find(n => n.dataset.id === String(nodeId))
        if (nodeElement) {
          nodeElement.remove()
          this.nodeTargets.forEach(n => { if (n.dataset.parentId === String(nodeId)) n.dataset.parentId = "" })
          this.drawLines()
        }
        this.closeDeleteModal()
      }
    })
  }

  startDrag(e) {
    if (e.button === 2 || e.target.closest('.fab')) return; 
    const node = e.target.closest('.map-node')
    this.mouseStartX = e.clientX; this.mouseStartY = e.clientY

    if (node) { 
      // ВАЖНО: Регистрируем клик по кружку (чтобы перейти на его страницу), 
      // НО если юзер не админ — не разрешаем ему перемещать кружок!
      this.draggingNode = node; 
      if (this.isAdminValue) {
        this.draggingNode.style.zIndex = 1000 
      }
    } else { 
      // Двигать карту могут все
      this.isDraggingMap = true; 
      this.startX = e.clientX - this.translateX; 
      this.startY = e.clientY - this.translateY 
    }
  }

  drag(e) {
    if (this.draggingNode) {
      // ВАЖНО: Если юзер не админ — блокируем логику перетаскивания кружка
      if (!this.isAdminValue) return;

      e.preventDefault()
      const rect = this.canvasTarget.getBoundingClientRect()
      const x = (e.clientX - rect.left) / this.scale 
      const y = (e.clientY - rect.top) / this.scale
      this.draggingNode.style.left = `${x}px`; this.draggingNode.style.top = `${y}px`
      this.drawLines()
    } else if (this.isDraggingMap) {
      e.preventDefault()
      this.translateX = e.clientX - this.startX; this.translateY = e.clientY - this.startY
      this.updateTransform()
    }
  }

  endDrag(e) {
    if (e.button === 2 || e.target.closest('.fab')) return; 
    const deltaX = Math.abs(e.clientX - this.mouseStartX); const deltaY = Math.abs(e.clientY - this.mouseStartY)
    const isClick = deltaX < this.clickThreshold && deltaY < this.clickThreshold

    if (this.draggingNode) {
      if (this.isAdminValue) {
        this.draggingNode.style.zIndex = ''
      }
      
      if (isClick) { 
        // Если это был просто клик, совершаем переход (Доступно всем!)
        this.triggerTransition(this.draggingNode.dataset.id) 
      } else { 
        // Если это было перетаскивание, сохраняем координаты (Доступно только админу!)
        if (this.isAdminValue) {
          this.saveCoordinates(this.draggingNode) 
        }
      }
    }
    this.isDraggingMap = false; this.draggingNode = null
  }

  drawLines() {
    let svgHTML = ''
    this.nodeTargets.forEach(node => {
      const parentId = node.dataset.parentId
      if (parentId) {
        const parentNode = this.nodeTargets.find(n => n.dataset.id === String(parentId) && document.body.contains(n))
        if (parentNode) {
          const x1 = parseFloat(parentNode.style.left); const y1 = parseFloat(parentNode.style.top)
          const x2 = parseFloat(node.style.left); const y2 = parseFloat(node.style.top)
          const radius = 58 
          const angle = Math.atan2(y2 - y1, x2 - x1)
          const startX = x1 + Math.cos(angle) * radius; const startY = y1 + Math.sin(angle) * radius
          const endX = x2 - Math.cos(angle) * radius; const endY = y2 - Math.sin(angle) * radius
          const offset = Math.abs(endX - startX) * 0.5
          const path = `M ${startX} ${startY} C ${startX + offset} ${startY}, ${endX - offset} ${endY}, ${endX} ${endY}`
          svgHTML += `<path class="connection" d="${path}" fill="none" />`
        }
      }
    })
    this.svgTarget.innerHTML = svgHTML
  }

  triggerTransition(id) {
    const flash = document.getElementById('flash-overlay')
    if (flash) {
      flash.classList.add('active')
      setTimeout(() => { window.location.href = `/works/${id}` }, 500)
    }
  }

  saveCoordinates(node) {
    const nodeId = node.dataset.id; const newX = parseFloat(node.style.left); const newY = parseFloat(node.style.top)
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(`/maps/update_coordinates/${nodeId}`, { method: 'PATCH', headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken }, body: JSON.stringify({ pos_x: newX, pos_y: newY }) })
  }
}