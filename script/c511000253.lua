--混沌幻魔アーミタイル (Anime)
--Armityle the Chaos Phantom (Anime)
function c511000253.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,6007213,32491822,69890967)
	--Special Summon with Dimension Fusion Destruction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Cannot be Destroyed by Battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c511000253.atktg)
	e3:SetOperation(c511000253.atkop)
	c:RegisterEffect(e3)
	--Control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65305468,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c511000253.cttg)
	e4:SetOperation(c511000253.ctop)
	c:RegisterEffect(e4)
end
function c511000253.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:GetControler()~=tp and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable() 
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)   
end
function c511000253.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) 
		and c:IsAttackable() and not c:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_CHAIN)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(10000)
		c:RegisterEffect(e1)
		Duel.CalculateDamage(c,tc)
	end
end
function c511000253.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c511000253.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetControl(c,1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(c511000253.furytg)
		e1:SetOperation(c511000253.furyop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_TURN_END)
		e2:SetCountLimit(1)
		e2:SetLabel(c:GetControler())
		e2:SetLabelObject(e1)
		e2:SetCondition(c511000253.retcon)
		e2:SetOperation(c511000253.retop)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511000253.furytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c511000253.furyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c511000253.retcon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=e:GetHandler()
	if c:IsControler(1-e:GetLabel()) then e:Reset() return false end
	return not te or not te:IsActivatable(c:GetControler())
end
function c511000253.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetLabel()
	if c:IsControler(p) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
		local zone=Duel.SelectDisableField(p,1,0,LOCATION_MZONE,0)>>16
		Duel.GetControl(tc,1-p,0,0,zone)
	end
end